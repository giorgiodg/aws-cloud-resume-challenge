import type { Site, Metadata, BlogEntry, PersonalLink } from "@types";
import { Globe, Book, Github, Linkedin } from "@lucide/astro";

export const SITE: Site = {
  NAME: "giorgiodg.cloud",
  EMAIL: "",
};

export const HOME: Metadata = {
  TITLE: "The Cloud Resume Challenge",
  DESCRIPTION:
    "This is the website I have built within the scope of the AWS Cloud Resume Challenge. Check it out",
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
      "My journey into the Cloud Resume Challenge: making the website dynamic",
    description: "Part 2",
  },
  {
    href: "https://giorgiodg.it/blog/cloud-resume-challenge-automating-frontend",
    title:
      " My journey into the Cloud Resume Challenge: automating Frontend Deployment with CI/CD",
    description: "Part 3",
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

export const LAMBDA_URL: string =
  "https://xaegc44e7d42ane3eijb7wtqh40sormf.lambda-url.eu-west-3.on.aws/";
