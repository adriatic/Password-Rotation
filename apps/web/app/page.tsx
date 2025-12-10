import Link from "next/link";

export default function Home() {
  return (
    <main className="flex flex-col items-center mt-20">
      <h1 className="text-4xl font-bold mb-4">Password Rotation UI</h1>
      <Link href="/dashboard" className="text-blue-600 underline">
        Go to Dashboard →
      </Link>
    </main>
  );
}
