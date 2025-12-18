"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";

export default function LoginPage() {
  const router = useRouter();

  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");

  
  async function handleLogin() {
  setError("");

  const res = await fetch("/api/auth/login", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ email, password }),
  });

  if (!res.ok) {
    const data = await res.json();
    setError(data.error ?? "Login failed");
    return;
  }

  router.push("/dashboard");
}


  return (
    <main className="flex items-center justify-center min-h-screen p-6">
      <div className="w-full max-w-sm rounded-xl bg-white p-6 shadow">
        <h1 className="text-xl font-semibold mb-4">Log in</h1>

        <label className="block mb-3">
          <span className="block text-sm mb-1">Email</span>
          <input
            className="w-full rounded border px-3 py-2"
            value={email}
            onChange={(e: React.ChangeEvent<HTMLInputElement>) =>
              setEmail(e.target.value)
            }
            autoComplete="email"
          />
        </label>

        <label className="block mb-4">
          <span className="block text-sm mb-1">Password</span>
          <input
            className="w-full rounded border px-3 py-2"
            type="password"
            value={password}
            onChange={(e: React.ChangeEvent<HTMLInputElement>) =>
              setPassword(e.target.value)
            }
            autoComplete="current-password"
          />
        </label>

        {error ? (
          <p className="text-sm mb-3" role="alert">
            {error}
          </p>
        ) : null}

        <button
          className="w-full rounded bg-black px-4 py-2 text-white"
          onClick={handleLogin}
        >
          Log in
        </button>

        <div className="mt-4 flex justify-between text-sm">
          <a className="underline" href="/signup">
            Sign up
          </a>
          <a className="underline" href="/forgot-password">
            Forgot password?
          </a>
        </div>
      </div>
    </main>
  );
}
