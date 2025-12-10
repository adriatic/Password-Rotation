"use client";

import { useAuth } from "@password-rotation/auth";
import { Card } from "@password-rotation/ui";


export default function Dashboard() {
  const { user } = useAuth();

  return (
    <div className="p-10">
      <Card>
        <h2 className="text-xl font-bold mb-4">Dashboard</h2>
        {user ? (
          <p>Welcome, {user.email}</p>
        ) : (
          <p>You are not logged in.</p>
        )}
      </Card>
    </div>
  );
}
