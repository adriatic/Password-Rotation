"use client";

import { useState } from "react";
import { useAuth } from "@password-rotation/auth";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { Button, Input, Card } from "@password-rotation/ui";

export default function LoginPage() {
  const auth = useAuth();
  const router = useRouter();

  // AuthProvider not ready yet
  if (!auth) return null;

  const { login } = auth;

  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");

  const handleLogin = () => {
    try {
      login(email, password);
      router.push("/dashboard");
    } catch (err) {
      setError(err.message);
    }
  };

  return (
    <div className="flex items-center justify-center h-screen">
      <Card className="p-6 w-96">
        <h1 className="text-xl font-bold mb-4">Login</h1>

        {error && <p className="text-red-500">{error}</p>}

        <Input
          placeholder="Email"
          className="mb-3"
          value={email}
          onChange={(e) => setEmail(e.target.value)}
        />
        <Input
          placeholder="Password"
          className="mb-3"
          type="password"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
        />

        <Button className="w-full" onClick={handleLogin}>Login</Button>

        <div className="flex justify-between mt-4">
          <Link href="/signup" className="text-blue-600">Sign Up</Link>
          <Link href="/forgot-password" className="text-blue-600">
            Forgot Password?
          </Link>
        </div>
      </Card>
    </div>
  );
}
