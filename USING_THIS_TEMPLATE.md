# Using this template

Delete this file once you are set up.

## 1. Start a project

1. On GitHub: **Use this template → Create a new repository**.
2. Clone it with GitHub Desktop.
3. In Git Bash, inside the repo folder:
   ```bash
   bash tools/init.sh "My Project Name"
   ```
   This fills in the project name, the `OWNER/REPO` links and today's date.
4. Commit and push.

## 2. Put your KiCad project in

- Copy the project into `hardware/v1/kicad/`.
- The root schematic must have the **same name as the project file**: `Name.kicad_pro` and `Name.kicad_sch`.
- Several boards: give each board its own folder and its own `.kicad_pro`
  (`hardware/v1/kicad/power/power.kicad_pro`, ...). The scripts find all of them.
- A second revision goes in `hardware/v2/kicad/`. Nothing in the workflows needs editing.
  Freeze an old revision by moving it to `hardware/archive/v1/` (archive is skipped).

## 3. Set up the symbol fields once

In KiCad: **Schematic Setup → General → Field Name Templates**, add `Mfr. No` and `Description`.
New symbols then get these fields automatically. Fill `Mfr. No` for every part you buy, and tick
**Exclude from BOM** on test points, mounting holes, logos and unused gates.

If you call the field something else, change `MFR_FIELD` in `.github/workflows/release.yml`.

## 4. Off-board parts

List screws, standoffs, the enclosure, the transformer, fuses and so on in
`hardware/v1/bom/extras.csv` (two columns: `Manufacturer Part Number,Quantity`).
Save it as **CSV UTF-8** (in Excel: Save As → CSV UTF-8), not as an Excel file.

## 5. Check the automation

- **Actions → Docs → Run workflow**: rebuilds `docs/generated/`. It also runs on its own when you push
  changes to `.kicad_*` files. After it runs, **pull in GitHub Desktop** to get the generated files.
- **Actions → Release → Run workflow**: test run, files appear under "Artifacts" on the run page.
- **A real release**: create a tag starting with `v` (`v1.0`) on the latest commit and push it.

## 6. Clean up

- Delete folders you don't need (`firmware/`, `mechanical/`).
- Delete `SAFETY.md` if nothing is dangerous, and keep it if the device uses mains, high voltage or batteries.
- Add a `LICENSE` file (**Add file → Create new file → name it LICENSE** shows a license picker on GitHub).
- Uncomment the image and link lines in `README.md` as the files appear.

## What is generated and what you write

| You write and commit | Generated, never commit by hand |
|---|---|
| KiCad files, `extras.csv`, docs, README images | gerbers, BOM CSVs, PDFs, STEP (release page) |
| `docs/` pages | `docs/generated/` (rebuilt by the Docs workflow) |
