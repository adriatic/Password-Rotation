"use client";

import { useState } from "react";
import { useAuth } from "@password-rotation/auth";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { Button, Input, Card } from "@password-rotation/ui";

export default function SignupPage() {
  // ✔ Hooks always run
  const auth = useAuth();
  const signup = auth?.signup;
  const router = useRouter();

  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [confirm, setConfirm] = useState("");
  const [error, setError] = useState("");

  const handleSignup = () => {
    if (!signup) return; // AuthProvider not ready

    if (password !== confirm) {
      setError("Passwords do not match");
      return;
    }

    try {
      signup(email, password);
      router.push("/dashboard");
    } catch (err) {
      setError(err.message);
    }
  };

  // ✔ Conditional rendering AFTER hooks
  if (!auth) {
    return <div className="p-10 text-gray-500">Loading...</div>;
  }

  return (
    <div className="flex items-center justify-center h-screen">
      <Card className="p-6 w-96">
        <h1 className="text-xl font-bold mb-4">Create Account</h1>

        {error && <p className="text-red-600">{error}</p>}

        <Input
          placeholder="Email"
          className="mb-3"
          value={email}
          onChange={(e) => setEmail(e.target.value)}
        />

        <Input
          placeholder="Password"
          type="password"
          className="mb-3"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
        />

        <Input
          placeholder="Confirm Password"
          type="password"
          className="mb-3"
          value={confirm}
          onChange={(e) => setConfirm(e.target.value)}
        />

        <Button className="w-full" onClick={handleSignup}>
          Sign Up
        </Button>

        <div className="text-sm mt-4 text-right">
          <Link href="/login" className="text-blue-600">
            Back to Login
          </Link>
        </div>
      </Card>
    </div>
  );
}
