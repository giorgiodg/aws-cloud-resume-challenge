export type Site = {
  NAME: string;
  EMAIL: string;
};

export type Metadata = {
  TITLE: string;
  DESCRIPTION: string;
};

export type BlogEntry = {
  href: string;
  title: string;
  description: string;
};

export type PersonalLink = {
  name: string;
  href: string;
  icon?: any;
};
