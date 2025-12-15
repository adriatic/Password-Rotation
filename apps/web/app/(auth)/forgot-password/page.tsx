"use client";

import { useState } from "react";
import { useAuth } from "@password-rotation/auth";
import Link from "next/link";

export default function ForgotPasswordPage() {
  const { forgotPassword } = useAuth();
  const [email, setEmail] = useState("");
  const [sent, setSent] = useState(false);
  const [error, setError] = useState("");

  const handleSubmit = (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    setError("");

    try {
      forgotPassword(email); // throws if not found
      setSent(true);
    } catch (err: unknown) {
      const message =
        err instanceof Error ? err.message : "Unknown error occurred";
      setError(message);
    }
  };

  return (
    <div className="flex items-center justify-center h-screen">
      <div className="border p-6 rounded-lg shadow-md w-96 bg-white">
        <h1 className="text-xl font-bold mb-4 text-center">Reset Password</h1>

        {sent ? (
          <p className="text-green-600 text-center mb-4">
            If the email exists, reset instructions have been sent.
          </p>
        ) : (
          <form onSubmit={handleSubmit} className="flex flex-col">
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

            {error && (
              <p className="text-red-600 text-sm mb-3 text-center">{error}</p>
            )}

            <button
              type="submit"
              className="bg-gray-200 hover:bg-gray-300 p-2 rounded"
            >
              Send Reset Link
            </button>
          </form>
        )}

        <div className="flex justify-between mt-4 text-sm">
          <Link href="/login" className="text-blue-600 hover:underline">
            Back to Login
          </Link>

          <Link href="/signup" className="text-blue-600 hover:underline">
            Sign Up
          </Link>
        </div>
      </div>
    </div>
  );
}
