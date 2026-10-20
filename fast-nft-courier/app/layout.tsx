import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "Fast NFT Courier | Move With Confidence",
  description: "Courier, parcel delivery and shipment tracking.",
};

export default function RootLayout({ children }: Readonly<{ children: React.ReactNode }>) {
  return <html lang="en"><body>{children}</body></html>;
}
