# Your wedding website, from zero

A complete guide to building a wedding invite site like this one: a clean
one-page site with your names, your story, the schedule with map links, a
photo gallery, and an RSVP form — with **free hosting, forever**.

No coding knowledge required. It takes an afternoon, and a willingness to try.

> A note on where this guide came from: a friend built a demo site and this
> stack for their own wedding, and wrote this so you could pick it up without
> needing to be part of that conversation. Everything you need is below —
> you shouldn't need anything else to get moving.

---

## Recommended: start from the ready-made kit

**<https://github.com/eugenionerelli/wedding-invite-starter-kit>**

This is the fastest, most tested path — a complete, working wedding invite
site (placeholder names, real design, everything wired up) that you make
your own in a few clicks, no account beyond GitHub needed:

1. On that repo's page, click the green **"Use this template"** button
   (top right, next to "Code"). This gives you your own independent copy —
   not a fork, a fresh repository with your name on it.
2. Clone it, open `index.html` to see the starting point, then follow the
   **README in that repo** — it has its own complete guide, including a
   local visual editor (no Webstudio, no account, edits your real files
   directly) that's already connected and tested.

Everything below in *this* document still applies conceptually (accounts,
Google Maps links, going live, the pre-launch checklist) — the starter
kit's own README covers the same ground with commands and file paths
specific to what you'll actually have on disk. Read whichever one you land
on first; they agree with each other.

**If you'd rather build with Webstudio instead** (a different, richer
canvas — see the comparison in *Part 3* below), or if a friend already
designed your site *in Webstudio* and wants to hand it to you, keep
reading: **[Part 4](#part-4--receiving-a-site-someone-built-for-you)**
covers that path.

---

## What you'll end up with

A site at an address of your own — `https://yournames.pages.dev` or
`https://yourname.github.io/wedding/` — that you send around on WhatsApp or by
text. Inside: your names, your story, the day's schedule with buttons that
open Google Maps, a photo gallery, and a form for guests to confirm they're
coming.

**Cost: $0 for hosting, forever.** A domain of your own
(`yournames.com`) is optional, roughly $10–15/year.

---

## The three choices to make first

### 1. Who designs the site?

| | How it works | Best for |
|---|---|---|
| **Webstudio** | Drag elements into a canvas, like Canva but for websites | You want to see what you're doing |
| **An AI that writes the code** | You describe it in words, it builds it | You can explain clearly and trust the result |
| **Both together** | Design in the canvas, ask the AI for the tedious parts | The fastest path — recommended |

### 2. Where does it live online?

**GitHub Pages** and **Cloudflare Pages** are both free forever.

- **GitHub Pages** — address like `yourname.github.io/wedding`. The project
  has to be public (anyone can read the code — not a real concern here).
- **Cloudflare Pages** — address like `yournames.pages.dev`, a **nicer-looking
  URL**, and it also works with a private project.

*Recommendation:* Cloudflare, for the cleaner address.

### 3. Do you need an AI subscription?

Only if you choose to have an AI help you build it. Prices verified
**July 2026** — double-check them, they shift often.

| | Cost | What it gets you |
|---|---|---|
| **Claude Pro** | ~$20/month | Includes Claude Code. Plenty for this project. |
| **ChatGPT Plus** (Codex) | ~$20/month | Includes Codex. Equivalent option. |
| Higher tiers | $100–200/month | **You don't need these.** They're for people coding all day, every day. |

One month is enough to finish the site. Cancel after.

> **If you'd rather not spend anything:** do it all by hand in Webstudio.
> It's completely free and works perfectly well on its own — the AI saves
> time, it isn't required.

**Sources:** [Claude pricing](https://claude.com/pricing) ·
[Codex pricing](https://developers.openai.com/codex/pricing)

---

## Part 1 — Accounts (20 minutes)

All free. Each needs an email and a password.

1. **GitHub** → [github.com/signup](https://github.com/signup)
   This is the "drawer" your site lives in. Note your username — it ends up
   in your site's address.

2. **Webstudio** → [webstudio.is](https://webstudio.is)
   The design tool. **The free "Hobby" plan is genuinely sufficient** —
   verified directly against Webstudio's pricing page (July 2026): unlimited
   projects and pages, static export included, and the share-link permission
   the automation needs (see Part 3) is explicitly free, not a paid feature.
   You will not need to pay Webstudio anything for this project.

3. **Cloudflare** *(if you picked that one)* →
   [dash.cloudflare.com/sign-up](https://dash.cloudflare.com/sign-up)

4. **Claude or ChatGPT** *(only if you want AI help)* — paid subscription.

> Turn on **two-factor authentication** on GitHub at least. Two minutes now
> saves you a headache later.

---

## Part 2 — Setting up your computer (15 minutes)

Only needed if you'll use AI help or run commands from a terminal. **If
you're designing purely in Webstudio and publishing by dragging a folder,
skip to Part 5.**

The *Terminal* is the app where you type commands. On a Mac: `Cmd + Space`,
type "Terminal", Enter. It looks intimidating, but here you're copying and
pasting — nothing more.

### Node.js

The engine that runs the tools. Check if it's already there:

```bash
node --version
```

`v20` or higher means you're set. If it says "command not found," download
the **LTS** version from [nodejs.org](https://nodejs.org) and install it.

### Git

Keeps a history of changes and sends your site to GitHub.

```bash
git --version
```

If it's missing, your Mac will offer to install it — accept. Then introduce
yourself:

```bash
git config --global user.name "Your Name"
git config --global user.email "you@email.com"
```

### Claude Code *(only with a Claude subscription)*

```bash
npm install -g @anthropic-ai/claude-code
claude
```

It'll ask you to sign in on first run. For Codex instead:
`npm install -g @openai/codex`, then `codex`.

---

## Part 3 — Designing the site

1. On [webstudio.is](https://webstudio.is), **new project**, blank page.
2. Build out the sections. An order that works well:

   - **Cover** — big names, the date, nothing else. The empty space here
     *is* the elegance.
   - **Your story** — two paragraphs, no more.
   - **The schedule** — for each moment: time, venue, address, a Maps button.
   - **Gallery** — six photos is plenty.
   - **RSVP** — name, attending yes/no, number of guests.
   - **Closing** — a line you both like.

### The Google Maps buttons

The single most-used part of the site. Search the venue on
[maps.google.com](https://maps.google.com) → **Share** → **Copy link**, and
paste it into the button. Or use this format, which never expires:

```
https://www.google.com/maps/search/?api=1&query=Venue+Name+City
```

(spaces become `+`)

Set the buttons to open in a **new tab**, so clicking doesn't lose the
invite page.

### Five details that make the difference

1. **Don't use pure white for the background.** A warm off-white
   (`#F6F4EF` is a good starting point) reads as paper; pure white reads as
   a document.
2. **Leave a lot of empty space.** It'll feel like too much in the canvas.
   It isn't — that's what separates an elegant invite from a cluttered page.
3. **Two fonts, three at most** if you know what you're doing. All free on
   [Google Fonts](https://fonts.google.com).
4. **Check it on a phone while you work**, not at the end: almost everyone
   will open the link on their phone.
5. **Write alt text on every photo** — screen readers rely on it.

### If you want AI help

Webstudio has an official connection for Claude Code and Codex. From your
project folder:

```bash
npx webstudio init --link "<share-link>" --template ssg
npx webstudio sync
npx webstudio connect claude      # or: codex
```

Get the *share link* from your Webstudio project: **Share** → new link with
**Build** permission → check the box for **API access** if you see one
(confirmed free — no Pro plan needed). Without that access, nothing will
connect.

Restart Claude Code, and you can ask things like: *"change the palette to
sage green"*, *"show me how this looks on an iPhone"*.

> ⚠️ That link is **like a password** — whoever has it can edit the site.
> Never put it in a file that ends up on GitHub, never send it over WhatsApp.

### If Webstudio's canvas doesn't suit you

Webstudio always starts from a blank page — it can't import an existing
HTML file. If you'd rather work directly on real HTML/CSS files (yours, or
ones someone wrote for you), the free open-source alternative is
[**GrapesJS**](https://github.com/GrapesJS/grapesjs): it edits real HTML and
CSS directly, runs entirely on your own computer, no account needed. It's
more of a developer's tool than a polished no-code app, so expect a bit more
setup — but it costs nothing and has no such import limitation.

---

## Part 4 — Receiving a site someone built for you

If a friend (or an AI working on their behalf) already designed your site
inside Webstudio, moving it into an account you own and control takes three
steps on your side:

1. Create your own free Webstudio account and a **new, empty project**.
2. Inside that project: **Share** → new link with **Build** permission
   (confirmed free — no paid plan required) → copy it.
3. Send that link to whoever built the site. From their side, one command
   pushes their finished project straight into yours:

   ```bash
   webstudio import --to "<the link you just sent>"
   ```

That's it — the design lands in a project only you control. From there,
everything in Part 5 (exporting and publishing) works exactly the same,
and you can also open the canvas yourself any time to tweak it.

> Same warning as above: that link lets whoever holds it edit your project.
> Share it once, over a channel you trust (not a public group chat), and only
> with the person actually doing the import.

---

## Part 5 — Putting it online (15 minutes)

### Export

In Webstudio: **Publish** → **Export** → **Build and download static site**.
You'll get a `.zip`. It must be the *static site* export, not the JavaScript
app — free hosts only serve static files.

Unzip it: inside you'll find an `index.html` and a few folders.

### Option A — Cloudflare Pages (the simplest)

No commands needed.

1. [dash.cloudflare.com](https://dash.cloudflare.com) → **Workers & Pages**
2. **Create** → **Pages** tab → **Upload assets**
3. Project name: whatever you want in the address (e.g. `annaandmark`)
4. **Drag in the unzipped folder**
5. Done — you're live at `https://annaandmark.pages.dev`

To update later: re-export and re-upload from the same page.

### Option B — GitHub Pages

1. Create a new project at [github.com/new](https://github.com/new), name it
   `wedding`, mark it **Public**, leave everything else unchecked.
2. In the Terminal, from the site's folder:

```bash
git init -b main
git add .
git commit -m "Our invite"
git remote add origin https://github.com/YOURNAME/wedding.git
git push -u origin main
```

3. On the project page: **Settings** → **Pages** → Source: *Deploy from a
   branch* → Branch `main`, folder `/ (root)` → **Save**.
4. After about a minute, you're live at
   `https://YOURNAME.github.io/wedding/`.

To update: `git add . && git commit -m "updated" && git push`.

> **The fix that saves an evening.** If the site loads with **no styling at
> all**, create an empty file named `.nojekyll` in the main folder and
> republish. GitHub silently drops any folder starting with `_`, and page
> builders generate those constantly. From the terminal:
> `touch .nojekyll`

---

## Part 6 — Before you send it to guests

- [ ] Opened it **on a phone**, not just a laptop
- [ ] All the Maps buttons go to the right place
- [ ] The RSVP form **actually reaches you** with a test submission
- [ ] Names, dates, and times checked twice (a typo'd date is the classic mistake)
- [ ] Sent the link to a friend outside the wedding, to see if it makes sense
      to someone with no context
- [ ] No home address or private phone number on the page: **anyone with the
      link can open it**
- [ ] Site hidden from search engines (in Webstudio: look for *noindex* in
      the page settings)

---

## A domain of your own (optional)

`annaandmark.com` costs roughly $10–15/year from a registrar like
[Cloudflare](https://domains.cloudflare.com), and connects free to either
platform (on Cloudflare: project → *Custom domains*).

> "Free" domains like `.tk` aren't a real option anymore — Freenom stopped
> issuing them. It's either the free subdomain, or a domain you pay for.

---

## If you get stuck

| Problem | Usual cause |
|---|---|
| Site with no styling | Missing `.nojekyll` (see above) |
| "Permission denied" with git | Wrong username in the address, or you need a token instead of a password |
| The AI can't see Webstudio | API access wasn't checked on the link, or you haven't restarted the client |
| Blank page | The main file must be named exactly `index.html` |
| Changes not showing | Wait a minute, then hard-refresh with `Cmd + Shift + R` |

And if you're truly stuck: ask an AI, pasting **the exact error message**.
That's where they're actually useful.

---

## The one piece of advice that matters most

Do the ugly version **first**. Names, date, venue, one Maps button: live
within an hour. Make it beautiful after.

The opposite — three weeks picking the perfect font and never publishing —
is the single most common way to end up with no site at all.

Congratulations. 🥂
