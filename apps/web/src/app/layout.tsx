import type { Metadata } from "next";
import { Geist, Geist_Mono } from "next/font/google";
import "./globals.css";

const geistSans = Geist({
  variable: "--font-geist-sans",
  subsets: ["latin"],
});

const geistMono = Geist_Mono({
  variable: "--font-geist-mono",
  subsets: ["latin"],
});

export const metadata: Metadata = {
  title: "Workout",
  description: "A dashboard for viewing the weight progression of workouts.",
  icons: {
    icon: [
      {
        url: "/workout-icon-square-light.png",
        media: "(prefers-color-scheme: light)",
      },
      {
        url: "/workout-icon-square.png",
        media: "(prefers-color-scheme: dark)",
      },
    ],
    apple: "/workout-icon-square.png",
  },
};


export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html
      lang="en"
      suppressHydrationWarning
      className={`${geistSans.variable} ${geistMono.variable} h-full antialiased`}
    >
      <body className="min-h-full flex flex-col">{children}</body>
    </html>
  );
}
