"use client";

import type { ReactNode } from "react";
import { Providers } from "../providers";
import { Protected } from "../protect";

export default function DashboardLayout({ children }: { children: ReactNode }) {
  return (
    <Providers>
      <Protected>{children}</Protected>
    </Providers>
  );
}
