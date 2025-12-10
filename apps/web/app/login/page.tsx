"use client";

import { useAuth } from "@password-rotation/auth";
import { Button } from "@password-rotation/ui";

export default function Login() {
  const { login } = useAuth();

  return (
    <main className="flex flex-col mt-20 items-center gap-4">
      <h1 className="text-2xl font-bold">Login</h1>
      <Button onClick={() => login("test@example.com")}>
        Fake Login as test@example.com
      </Button>
    </main>
  );
}
