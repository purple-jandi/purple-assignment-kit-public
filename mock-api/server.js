const express = require('express');
const multer = require('multer');
const cors = require('cors');
const morgan = require('morgan');
const path = require('path');
const fs = require('fs');
const jsonServer = require('json-server');

const app = express();
const port = 3000;

// Middleware
app.use(cors());
app.use(morgan('dev'));
app.use(express.json());
app.use('/uploads', express.static('uploads'));
app.use('/assets', express.static(path.join(__dirname, 'assets')));

// Ensure assets directory exists for uploads
const uploadDir = path.join(__dirname, 'assets');
if (!fs.existsSync(uploadDir)) {
    fs.mkdirSync(uploadDir, { recursive: true });
}

// Multer configuration for file uploads
const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        cb(null, uploadDir);
    },
    filename: (req, file, cb) => {
        const ext = path.extname(file.originalname);
        const name = path.basename(file.originalname, ext);
        cb(null, `${name}-${Date.now()}${ext}`);
    }
});

const upload = multer({ storage: storage });

// Mock Data
let feeds = [
    {
        id: 1,
        type: 'video',
        title: '퍼플영 서비스 소개',
        description: '의료/미용 모델 매칭 플랫폼 퍼플영을 소개합니다.',
        thumbnailUrl: 'https://picsum.photos/id/101/800/450',
        videoUrl: 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
        likes: 124,
        views: 1205,
        createdAt: '2026-01-20T10:00:00Z'
    },
    {
        id: 2,
        type: 'image',
        title: '신규 모델 프로필',
        description: '새롭게 등록된 전문 모델의 프로필 이미지입니다.',
        thumbnailUrl: 'https://picsum.photos/id/102/800/1200',
        imageUrl: 'https://picsum.photos/id/102/1600/2400',
        likes: 85,
        views: 450,
        createdAt: '2026-01-22T14:30:00Z'
    },
    {
        id: 3,
        type: 'video',
        title: '성형외과 매칭 사례',
        description: '실제 매칭이 완료된 사례의 인터뷰 영상입니다.',
        thumbnailUrl: 'https://picsum.photos/id/103/800/450',
        videoUrl: 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
        likes: 210,
        views: 3400,
        createdAt: '2026-01-25T09:15:00Z'
    }
];

// Routes

// 1. Read API - Feed List with Pagination
app.get('/api/feeds', (req, res) => {
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;

    const startIndex = (page - 1) * limit;
    const endIndex = page * limit;

    const results = feeds.slice(startIndex, endIndex);

    res.json({
        data: results,
        meta: {
            totalCount: feeds.length,
            page,
            limit,
            hasNext: endIndex < feeds.length
        }
    });
});

// 2. Create API - Post Post (Video/Image Upload)
app.post('/api/posts', upload.single('file'), (req, res) => {
    const { title, description, type } = req.body;
    const file = req.file;

    if (!file) {
        return res.status(400).json({ error: 'File is required' });
    }

    const newPost = {
        id: feeds.length + 1,
        type: type || (file.mimetype.startsWith('video') ? 'video' : 'image'),
        title: title || 'Untitled Post',
        description: description || '',
        thumbnailUrl: 'https://picsum.photos/id/104/800/450', // Mock thumbnail
        [file.mimetype.startsWith('video') ? 'videoUrl' : 'imageUrl']: `http://localhost:${port}/uploads/${file.filename}`,
        likes: 0,
        views: 0,
        createdAt: new Date().toISOString()
    };

    feeds.unshift(newPost); // Add to the beginning of the list

    res.status(201).json(newPost);
});

// 3. Update API - Like / View Count (Optimistic Update Demo)
app.patch('/api/feeds/:id/like', (req, res) => {
    const id = parseInt(req.params.id);
    const feed = feeds.find(f => f.id === id);

    if (!feed) {
        return res.status(404).json({ error: 'Feed not found' });
    }

    // Simulate network delay for testing optimistic updates
    setTimeout(() => {
        feed.likes += 1;
        res.json({ id: feed.id, likes: feed.likes });
    }, 1000);
});

app.patch('/api/feeds/:id/view', (req, res) => {
    const id = parseInt(req.params.id);
    const feed = feeds.find(f => f.id === id);

    if (!feed) {
        return res.status(404).json({ error: 'Feed not found' });
    }

    feed.views += 1;
    res.json({ id: feed.id, views: feed.views });
});

// Auth Simulation (Optional for this task but good to have)
app.post('/api/auth/login', (req, res) => {
    const { email } = req.body;
    if (email === 'test@purpleyoung.com') {
        res.json({
            accessToken: 'mock-access-token',
            refreshToken: 'mock-refresh-token',
            user: { id: 1, name: '테스터', role: 'admin' }
        });
    } else {
        res.status(401).json({ error: 'Invalid credentials' });
    }
});

// File Upload API
app.post('/upload', upload.single('file'), (req, res) => {
    const file = req.file;

    if (!file) {
        return res.status(400).json({ error: 'File is required' });
    }

    const mediaServerUrl = `http://localhost:8081/${file.filename}`;

    res.status(201).json({
        message: 'File uploaded successfully',
        url: mediaServerUrl,
        filename: file.filename
    });
});

// JSON Server (db.json 기반 모의 API)
const router = jsonServer.router(path.join(__dirname, 'data/db.json'));
const middlewares = jsonServer.defaults();

app.use(middlewares);

// Add default values for new items
app.use((req, res, next) => {
    if (req.method === 'POST' && req.path === '/items') {
        req.body.createdAt = req.body.createdAt || new Date().toISOString();
        req.body.likes = 0;
        req.body.views = 0;
        req.body.thumbnail = req.body.thumbnail || '';
        req.body.videoUrl = req.body.videoUrl || '';
        
        // 기존 데이터를 기반으로 max 아이디를 찾아 다음 id를 NumberString 타입으로 할당
        const items = router.db.get('items').value();
        if (items && items.length > 0) {
            const maxId = Math.max(...items.map(item => parseInt(item.id, 10) || 0));
            req.body.id = (maxId + 1).toString();
        } else {
            req.body.id = "1";
        }
    }
    if (req.method === 'GET' && req.path === '/items' && req.query.tag) {
        const tag = req.query.tag;
        const items = router.db.get('items').value();
        
        // Filter items that contain the requested tag
        const filteredItems = items.filter(item => 
            item.tags && Array.isArray(item.tags) && item.tags.includes(tag)
        );

        // Apply pagination (default json-server behavior)
        const page = parseInt(req.query._page, 10) || 1;
        const limit = parseInt(req.query._limit, 10) || 10;
        const startIndex = (page - 1) * limit;
        const endIndex = page * limit;
        
        const paginatedItems = filteredItems.slice(startIndex, endIndex);

        // Set total count header (X-Total-Count is standard for json-server)
        res.setHeader('X-Total-Count', filteredItems.length);
        res.setHeader('Access-Control-Expose-Headers', 'X-Total-Count');
        
        return res.json(paginatedItems);
    }

    // Like increment API
    if (req.method === 'PATCH' && req.path.match(/\/items\/[^\/]+\/like/)) {
        const id = req.path.split('/')[2];
        const item = router.db.get('items').find({ id }).value();
        if (item) {
            const updatedItem = router.db.get('items')
                .find({ id })
                .assign({ likes: (item.likes || 0) + 1 })
                .write();
            return res.json(updatedItem);
        }
        return res.status(404).json({ error: 'Item not found' });
    }

    // View increment API
    if (req.method === 'PATCH' && req.path.match(/\/items\/[^\/]+\/view/)) {
        const id = req.path.split('/')[2];
        const item = router.db.get('items').find({ id }).value();
        if (item) {
            const updatedItem = router.db.get('items')
                .find({ id })
                .assign({ views: (item.views || 0) + 1 })
                .write();
            return res.json(updatedItem);
        }
        return res.status(404).json({ error: 'Item not found' });
    }
    next();
});

app.use(router);

app.listen(port, '0.0.0.0', () => {
    console.log(`Mock API Server running at http://localhost:${port}`);
});
