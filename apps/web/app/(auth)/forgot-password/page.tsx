"use client";

import { useState } from "react";
import { useAuth } from "@password-rotation/auth";
import Link from "next/link";
import { Button, Input, Card } from "@password-rotation/ui";

export default function ForgotPasswordPage() {
  // ✔ Hooks run unconditionally
  const auth = useAuth();
  const forgotPassword = auth?.forgotPassword;

  const [email, setEmail] = useState("");
  const [sent, setSent] = useState(false);
  const [error, setError] = useState("");

  const handleReset = () => {
    if (!forgotPassword) return; // AuthProvider not ready

    try {
      forgotPassword(email);
      setSent(true);
    } catch (err) {
      setError(err.message);
    }
  };

  // ✔ Safe render gate AFTER hooks
  if (!auth) {
    return <div className="p-10 text-gray-500">Loading...</div>;
  }

  return (
    <div className="flex items-center justify-center h-screen">
      <Card className="p-6 w-96">
        <h1 className="text-xl font-bold mb-4">Reset Password</h1>

        {sent ? (
          <p className="text-green-600">
            A reset link has been (mock) sent to your email.
          </p>
        ) : (
          <>
            {error && <p className="text-red-600">{error}</p>}

            <Input
              placeholder="Email"
              className="mb-3"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
            />

            <Button className="w-full" onClick={handleReset}>
              Send Reset Link
            </Button>
          </>
        )}

        <div className="text-sm mt-4 text-right">
          <Link href="/login" className="text-blue-600">
            Back to Login
          </Link>
        </div>
      </Card>
    </div>
  );
}
