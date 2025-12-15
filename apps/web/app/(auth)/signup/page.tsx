"use client";

import { useState } from "react";
import { useAuth } from "@password-rotation/auth";
import Link from "next/link";
import { useRouter } from "next/navigation";

export default function SignupPage() {
  const { signup } = useAuth();
  const router = useRouter();

  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");

  const handleSignup = (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    setError("");

    try {
      signup(email, password);
      router.push("/dashboard");
    } catch (err: unknown) {
      const message =
        err instanceof Error ? err.message : "Unknown error occurred";
      setError(message);
    }
  };

  return (
    <div className="flex items-center justify-center h-screen">
      <div className="border p-6 rounded-lg shadow-md w-96 bg-white">
        <h1 className="text-xl font-bold mb-4 text-center">Sign Up</h1>

        <form onSubmit={handleSignup} className="flex flex-col">
          <input
            type="email"
            placeholder="Email"
            className="border p-2 mb-3"
            value={email}
            onChange={(e: React.ChangeEvent<HTMLInputElement>) =>
              setEmail(e.target.value)
            }
            required
          />

          <input
            type="password"
            placeholder="Password"
            className="border p-2 mb-3"
            value={password}
            onChange={(e: React.ChangeEvent<HTMLInputElement>) =>
              setPassword(e.target.value)
            }
            required
          />

          {error && (
            <p className="text-red-600 text-sm mb-3 text-center">{error}</p>
          )}

          <button
            type="submit"
            className="bg-gray-200 hover:bg-gray-300 p-2 rounded"
          >
            Sign Up
          </button>
        </form>

        <div className="flex justify-between mt-4 text-sm">
          <Link href="/login" className="text-blue-600 hover:underline">
            Login
          </Link>
          <Link
            href="/forgot-password"
            className="text-blue-600 hover:underline"
          >
            Forgot Password?
          </Link>
        </div>
      </div>
    </div>
  );
}
