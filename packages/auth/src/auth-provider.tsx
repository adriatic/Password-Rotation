"use client";

import { createContext, useContext, useState, useEffect } from "react";

// Define the shape of the AuthContext
export interface AuthContextType {
  user: { email: string } | null;
  login: (email: string, password: string) => void;
  signup: (email: string, password: string) => void;
  logout: () => void;
  forgotPassword: (email: string) => void;
}

// Create the context with proper typing
export const AuthContext = createContext<AuthContextType | null>(null);


// Mock user database stored in memory
const mockUsers = new Map<string, string>();

export function AuthProvider({ children }) {
  const [user, setUser] = useState<{ email: string } | null>(null);

  // Restore user session
  useEffect(() => {
    const saved = localStorage.getItem("auth_user");
    if (saved) setUser(JSON.parse(saved));
  }, []);

  const login = (email: string, password: string) => {
    const storedPass = mockUsers.get(email);
    if (storedPass !== password) {
      throw new Error("Invalid email or password");
    }
    const loggedUser = { email };
    setUser(loggedUser);
    localStorage.setItem("auth_user", JSON.stringify(loggedUser));
  };

  const signup = (email: string, password: string) => {
    if (mockUsers.has(email)) {
      throw new Error("User already exists");
    }
    mockUsers.set(email, password);
    const newUser = { email };
    setUser(newUser);
    localStorage.setItem("auth_user", JSON.stringify(newUser));
  };

  const logout = () => {
    setUser(null);
    localStorage.removeItem("auth_user");
  };

  const forgotPassword = (email: string) => {
    if (!mockUsers.has(email)) {
      throw new Error("Email not found");
    }
    return true;
  };

  const value: AuthContextType = {
    user,
    login,
    signup,
    logout,
    forgotPassword,
  };

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
}

export function useAuth() {
  return useContext(AuthContext);
}
