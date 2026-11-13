# Content pack confidence: Alpia and Zaki

Date: 2026-11-13. Packs: `Data/SKSE/Plugins/SkyrimNet-SlaveTats/Packs/alpia-slavetats.json`, `zaki-general.json`.

## Method

- First pass: text, category and position derived from the SlaveTats JSON names and sections.
- Second pass: textures rendered from their alpha channel, cropped and read. Alpia: all 267. Zaki: 93 of 841, covering every truncated name, Feet, Wrists, Head, counters, numbered variants, hearts and one sample each for Shoulder, Hip and Side. The other Zaki entries rely on names; every sampled name matched its texture.
- Textures that straddle UV seams (flanks, hips, butt cheeks) render as fragments and were not fully legible.
- Nothing was tested in game.
- `Chest` and `Belly` were added to the position vocabulary for these packs.

## Confidence levels

- high: text read from the texture, or (Zaki) stated by a name pattern that matched every sample.
- medium: partly legible, or placement approximated by the nearest position.
- low: placement guessed.

## Alpia Slavetats SE

| Confidence | Tattoos |
|---|---|
| high | 198 |
| medium | 67 |
| skipped | 2 |

- Installed sets only: Bondage, Crime, Public Whore 2, Toilet Prison. Beggar, Public Whore and General are not installed.
- Names often abbreviate the handwriting; about 120 entries were reworded or completed from the texture.
- Drawings, symbols, kanji and printed service lists are described from the texture.
- Category is the set name (`bondage`, `crime`, `whore`, `toilet`), not the individual text. Generic insults in the Crime set are therefore `crime`.
- Sections `Alpia Left`/`Alpia Right` sit on the flanks and hips and map to `Belly`.
- `PW` prefix treated as a set marker and dropped from the text.
- Two full-body tattoos share Section and Name between a face and a body texture; each is listed once.

### By section

| Section | high | medium | low | skipped |
|---|---|---|---|---|
| Alpia Face | 7 | 0 | 0 | 0 |
| Alpia Chest | 30 | 0 | 0 | 0 |
| Alpia Belly | 26 | 0 | 0 | 0 |
| Alpia Back | 46 | 0 | 0 | 0 |
| Alpia Butt | 1 | 18 | 0 | 0 |
| Alpia Arms | 29 | 1 | 0 | 0 |
| Alpia Legs | 59 | 1 | 0 | 0 |
| Alpia Left | 0 | 12 | 0 | 0 |
| Alpia Right | 0 | 14 | 0 | 0 |
| Alpia Full | 0 | 7 | 0 | 0 |
| Alpia FULL | 0 | 14 | 0 | 2 |

### Skipped entries

**duplicate Section/Name in source (face+body pair); kept once** (2)

FULL / Full - Public Whore; FULL / Full - Toilet Prison

### Medium entries

**texture split across UV seams; text taken from name** (18)

Butt / LBc - Spank me; Butt / RBc - Plug my ass; Butt / RBc - Days Plugged; Arms / L Lower Front - Bottom; Legs / R Lower Side - ropeslut; Butt / Butt - insert here; Butt / Butt - RA PE; Butt / Butt R - thief loot; Butt / RBc - make her cry; Butt / RBc - whip my ass; Butt / Lbc - Force it in; Butt / LBc - fuck asshole till rips; Butt / LBc - heart anal; Butt / LBc - I love backstabbing; Butt / Butt - Free Fuck Creampie Only; Butt / Butt - Toi let; Butt / RBc - convited to pounding; Butt / LBc - Clap my cheeks

**texture split across UV seams; text taken from name; flank or hip mapped to Belly** (21)

Left / Upper - submissive; Left / Lower - keep tied; Left / Lower - Days in Chastity; Right / Upper - rope bunny; Right / Lower - lost her keys; Right / Lower - Days Edged; Right / Upper - struggler; Right / Upper - Bimbo; Right / Upper - Bitch; Right / Upper - cumrag; Right / Lower - heart cock; Right / Lower - make me squeal; Left / Upper - fuckdoll; Left / Upper - Slut; Left / Upper - whore; Left / Lower - break her; Right / R Lower - Body No Mercy Only Cock; Right / Upper - cock wiper; Right / Lower - piss on me; Left / Upper - defiant bitch; Left / Lower - kanji public toilet

**full-body set; only the largest texts read** (15)

Full / Full - Bondage; Full / Full - Crime Addon; Full / Full - Crime Battery; Full / Full - Crime Defamation; Full / Full - Crime Prisoner; Full / Full - Crime Thief; Full / Full - Crime Whoring; FULL / Full - Public Whore; FULL / Full - Public Whore Addon 2; FULL / Full - Public Whore Addon; FULL / Full - Public Whore With Tramp Stamp Space; FULL / Full - Toilet Prison; FULL / Full - Toilet Public(misc); FULL / Full - Toilet Prison Addon 1 (body); FULL / Full - Toilet Prison Addon 2 (body)

**partly legible; texture split across UV seams; text taken from name; flank or hip mapped to Belly** (5)

Left / Lower - me her regret; Right / R Upper - PW Service List; Right / R Lower - PW Barcode Used to be Hero; Left / L Upper - PW Service List; Left / L Lower - PW Service Tally

**partly legible; texture split across UV seams; text taken from name** (2)

Butt / LBc - PW Fuck Meat Belongs To Town; Butt / RBc - PW Service List Use As U Like

**stage described from a downscaled view** (6)

FULL / Full - Toilet Prison progressive day 0 (body)(misc); FULL / Full - Toilet Prison progressive day 1 (body)(misc); FULL / Full - Toilet Prison progressive day 3 (body)(misc); FULL / Full - Toilet Prison progressive day 5 (body)(misc); FULL / Full - Toilet Prison progressive day 7 (body)(misc); FULL / Full - Toilet Prison progressive day 14 (body)(misc)

## Zaki Tattoos General Pack SE

| Confidence | Tattoos |
|---|---|
| high | 737 |
| medium | 99 |
| low | 5 |

- Position is high wherever the section names a region directly.
- Hands: sections `Left`/`Right` use SlaveTats area Hands, mapped to Left/Right Hand.
- Feet and Wrists cover both sides and map to `All Over`. Each Feet tattoo carries a different phrase per foot; the name gives only one.
- Truncated names resolved: “If I'm alone rape me” (now `rape`), “If I'm not screaming then your not hitting hard enough”, “Beat the shit out of me”, “Choke me till I'm purple”, “Born to serve cocks”.
- Numbered variants carry the same text at a different spot or angle on the face.
- Shoulder sits on the upper back between the shoulders and maps to `Back`.
- Head: small hearts; exact spot unverified.
- Hip maps to Upper Leg, belly sides to `Belly`.
- Categories come from keywords: `symbol`, `amputation`, `toilet`, `bondage`, `rape`, `slave`, `abuse`; everything else is `slut`. First match wins, so “Piss slave” is `toilet` and “Abuse my holes” is `abuse`.

### By section

| Section | high | medium | low | skipped |
|---|---|---|---|---|
| Zaki General Neck | 54 | 0 | 0 | 0 |
| Zaki General Face | 74 | 0 | 0 | 0 |
| Zaki General Forehead | 52 | 0 | 0 | 0 |
| Zaki General Left | 62 | 0 | 0 | 0 |
| Zaki General Mouth | 27 | 0 | 0 | 0 |
| Zaki General Right | 62 | 0 | 0 | 0 |
| Zaki General Shoulder | 0 | 24 | 0 | 0 |
| Zaki General Feet | 0 | 15 | 0 | 0 |
| Zaki General Full Body | 0 | 1 | 0 | 0 |
| Zaki General Chest | 30 | 0 | 0 | 0 |
| Zaki General Wrists | 0 | 3 | 0 | 0 |
| Zaki General Head | 0 | 0 | 5 | 0 |
| Zaki General Butt | 54 | 0 | 0 | 0 |
| Zaki General Breasts | 47 | 0 | 0 | 0 |
| Zaki General Arms | 62 | 0 | 0 | 0 |
| Zaki General Legs | 84 | 30 | 0 | 0 |
| Zaki General Belly | 67 | 26 | 0 | 0 |
| Zaki General Back | 62 | 0 | 0 | 0 |

### Low entries

**exact spot on the head unverified** (5)

Head / Heart 1; Head / Heart Hollow 1; Head / Heart Hollow 2; Head / Heart Hollow 3; Head / Heart Hollow 4

### Medium entries

**upper back between the shoulders, judged from UV position; one sample read** (24)

Shoulder / Abuse Me; Shoulder / Bitch; Shoulder / Break Me; Shoulder / Cum Slut; Shoulder / Dirty Slut; Shoulder / Dumb Slut; Shoulder / Free Fuck; Shoulder / Fuck My Ass; Shoulder / Heart Hollow; Shoulder / Ignore Me If I Say No; Shoulder / Make Me Gape; Shoulder / Make Me Scream; Shoulder / My Name Is Bitch; Shoulder / Obedient; Shoulder / Owned; Shoulder / Piss On Me; Shoulder / Property; Shoulder / Public Toilet; Shoulder / Rape Me; Shoulder / Sex Slave; Shoulder / Sextoy; Shoulder / Slave; Shoulder / Slut; Shoulder / Whore

**covers both feet; mapped to All Over; which foot carries which text unverified** (15)

Feet / Abuse My Holes; Feet / Bitch Break Me; Feet / Born; Feet / Cum Slut Addict; Feet / Give Me Bruises; Feet / Heart Hollow; Feet / I Always Swallow; Feet / I Love; Feet / I Love Pain; Feet / If Im Alone; Feet / Owned; Feet / Rape Me; Feet / Slave; Feet / Slut; Feet / Torture Me

**read from a downscaled view** (1)

Full Body / Amputate Full Body

**covers both wrists; mapped to All Over** (3)

Wrists / Heart; Wrists / Heart Hollow; Wrists / Slave

**hip mapped to Upper Leg; texture split across UV seams; text taken from name** (30)

Legs / Left Hip - Beat The Shit Out Of Me; Legs / Left Hip - Cocksleeve; Legs / Left Hip - Days Tied Up; Legs / Left Hip - Fuck Hole; Legs / Left Hip - Fuck Me Till Im Dead; Legs / Left Hip - I Always Swallow; Legs / Left Hip - Ignore Me If I Say No; Legs / Left Hip - Paint Me With Cum; Legs / Left Hip - Slave; Legs / Left Hip - Slave To Cock; Legs / Left Hip - Stretch My Holes; Legs / Left Hip - Whip Me; Legs / Right Hip - Abuse Me; Legs / Right Hip - Born Slave; Legs / Right Hip - Cum Addict; Legs / Right Hip - Cum In My Eyes; Legs / Right Hip - Dirty Slut; Legs / Right Hip - Give Me Bruises; Legs / Right Hip - Horny; Legs / Right Hip - I Can Take On 6 Guys; Legs / Right Hip - I Will Suck You Dry; Legs / Right Hip - Im Forbidden To Say No; Legs / Right Hip - Make Me Cry; Legs / Right Hip - My Name Is Bitch; Legs / Right Hip - Owned; Legs / Right Hip - Piss Slave; Legs / Right Hip - Put Me In My Place; Legs / Right Hip - Sextoy; Legs / Right Hip - Slave; Legs / Right Hip - Will Drop For Cock

**flank mapped to Belly; texture split across UV seams; text taken from name** (26)

Belly / Left Side - Anal Only; Belly / Left Side - Battered And Horny; Belly / Left Side - Cum Addict; Belly / Left Side - Cum Dump; Belly / Left Side - Fuck My Ass; Belly / Left Side - Hack My Limbs Off; Belly / Left Side - I Will Drink Your Piss; Belly / Left Side - Make Me Cry; Belly / Left Side - My Name Is Bitch; Belly / Left Side - Piss On Me; Belly / Left Side - Put Me In My Place; Belly / Left Side - Slave; Belly / Left Side - Whore; Belly / Right Side - Beat The Shit Out Of Me; Belly / Right Side - Best On All Fours; Belly / Right Side - Born To Serve; Belly / Right Side - Cum Slut; Belly / Right Side - Dominate Me; Belly / Right Side - Ignore Me If I Say No; Belly / Right Side - Make Me Cry; Belly / Right Side - Make Me Shit Blood; Belly / Right Side - No Gag Reflex; Belly / Right Side - Please Rape Me; Belly / Right Side - Slave; Belly / Right Side - Tie Me Up; Belly / Right Side - Use Me

