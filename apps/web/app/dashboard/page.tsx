"use client";

import { useLogout } from "../hooks/useLogout";

export default function DashboardHome() {
  const logout = useLogout();

  return (
    <main className="p-6">
      <p className="mb-4">Welcome to the Dashboard</p>
      <button
        className="rounded bg-black px-4 py-2 text-white"
        onClick={logout}
      >
        Log out
      </button>
    </main>
  );
}
