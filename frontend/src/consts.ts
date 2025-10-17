import type { Site, Metadata, BlogEntry, PersonalLink } from "@types";
import { Globe, Book, Github, Linkedin } from "@lucide/astro";

export const SITE: Site = {
  NAME: "giorgiodg.cloud",
  EMAIL: "",
};

export const HOME: Metadata = {
  TITLE: "Giorgio Delle Grottaglie",
  DESCRIPTION:
    "I am Giorgio Delle Grottaglie, and I do Technology stuff. Born and raised in the Heel of Italy, based in Rome.",
};

export const CREDITS: Metadata = {
  TITLE: "Credits",
  DESCRIPTION: "",
};

export const PAGE_404: Metadata = {
  TITLE: "404 Not Found",
  DESCRIPTION: "",
};

export const BLOG_ENTRIES: BlogEntry[] = [
  {
    href: "https://giorgiodg.it/blog/cloud-resume-challenge-aws-foundation",
    title:
      "My journey into the Cloud Resume Challenge: building the foundation on AWS",
    description: "Part 1",
  },
  {
    href: "https://giorgiodg.it/blog/cloud-resume-challenge-website-dynamic",
    title:
      "My journey into the Cloud Resume Challenge: making the website dynamic ",
    description: "Part 2",
  },
];

export const PERSONAL_LINKS: PersonalLink[] = [
  {
    name: "Website",
    href: "https://giorgiodg.it/",
    icon: Globe,
  },
  {
    name: "GitHub",
    href: "https://github.com/giorgiodg/",
    icon: Github,
  },
  {
    name: "LinkedIn",
    href: "https://www.linkedin.com/in/giorgiodellegrottaglie/",
    icon: Linkedin,
  },
  {
    name: "Medium",
    href: "https://medium.com/@giorgio.dg",
    icon: Book,
  },
];
