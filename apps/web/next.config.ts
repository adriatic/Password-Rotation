import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  // Turbopack defaults are OK; App Router is always enabled
  reactStrictMode: true,

  // These are optional but reduce noise
  typescript: {
    ignoreBuildErrors: false,
  },
  
};

export default nextConfig;
