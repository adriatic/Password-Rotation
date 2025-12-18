import { cookies } from "next/headers";
import { db } from "../../../../../backend/db";

export async function POST() {
  const cookieStore = await cookies();
  const token = cookieStore.get("session")?.value;

  if (token) {
    await db.session.deleteMany({
      where: { token },
    });
  }

  cookieStore.set("session", "", {
    httpOnly: true,
    path: "/",
    maxAge: 0,
  });

  return new Response(null, { status: 204 });
}
