import defaultTheme from "tailwindcss/defaultTheme";

/** @type {import('tailwindcss').Config} */
export default {
  darkMode: ["class"],
  content: ["./src/**/*.{astro,html,js,jsx,md,mdx,svelte,ts,tsx,vue}"],
  theme: {
    extend: {
      fontFamily: {
        sans: ["Inter", ...defaultTheme.fontFamily.sans],
        serif: ["Lora", ...defaultTheme.fontFamily.serif],
      },
      typography: ({ theme }) => ({
        DEFAULT: {
          css: {
            "code::before": { content: "none" },
            "code::after": { content: "none" },
            code: {
              backgroundColor: theme("colors.zinc.800"),
              color: theme("colors.zinc.100"),
              borderRadius: "0.25rem",
              padding: "0.15rem 0.05rem",
            },
          },
        },
      }),
    },
  },
  plugins: [require("@tailwindcss/typography")],
};
