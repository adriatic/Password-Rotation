"use client";

import { useAuth } from "@password-rotation/auth";
import { useState } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";

export default function LoginPage() {
  const { login } = useAuth();
  const router = useRouter();

  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);

  const handleLogin = () => {
    setError(null);
    setLoading(true);

    try {
      login(email.trim(), password);
      router.push("/dashboard");
    } catch (err: unknown) {
      if (err instanceof Error) {
        setError(err.message);
      } else {
        setError("Unknown error occurred");
      }
    } finally {
      setLoading(false);
    }
  };

  return (
    <main className="flex flex-col items-center mt-32 space-y-6">
      <h1 className="text-3xl font-bold">Login</h1>

      <div className="flex flex-col space-y-4 w-80">
        <input
          type="email"
          placeholder="Email"
          className="border p-2 rounded"
          value={email}
          onChange={(e: React.ChangeEvent<HTMLInputElement>) =>
            setEmail(e.target.value)
          }
        />

        <input
          type="password"
          placeholder="Password"
          className="border p-2 rounded"
          value={password}
          onChange={(e: React.ChangeEvent<HTMLInputElement>) =>
            setPassword(e.target.value)
          }
        />

        {error && <p className="text-red-600 text-sm">{error}</p>}

        <button
          onClick={handleLogin}
          disabled={loading}
          className="bg-black text-white p-2 rounded disabled:opacity-50"
        >
          {loading ? "Logging in…" : "Login"}
        </button>

        <div className="flex justify-between text-sm mt-2 w-full">
          <Link href="/signup" className="underline">
            Sign Up
          </Link>
          <Link href="/forgot-password" className="underline">
            Forgot Password?
          </Link>
        </div>
      </div>
    </main>
  );
}
