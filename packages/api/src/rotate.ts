export async function rotateNow() {
  const res = await fetch("/api/rotate", { method: "POST" });
  return res.json();
}
