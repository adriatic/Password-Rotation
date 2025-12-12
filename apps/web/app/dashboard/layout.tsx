export default function DashboardLayout({ children }: { children: React.ReactNode }) {
  return (
    <section style={{ padding: "2rem" }}>
      <h1>Dashboard</h1>
      {children}
    </section>
  );
}
