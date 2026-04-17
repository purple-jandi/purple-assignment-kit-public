import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
    title: "퍼플영 프론트엔드 과제",
    description: "Senior Frontend Developer Assignment Kit",
};

export default function RootLayout({
    children,
}: Readonly<{
    children: React.ReactNode;
}>) {
    return (
        <html lang="ko">
            <body>{children}</body>
        </html>
    );
}
