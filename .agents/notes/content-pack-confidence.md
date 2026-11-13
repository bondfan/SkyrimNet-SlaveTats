# Content pack confidence: Alpia and Zaki

Date: 2026-11-13. Packs: `Data/SKSE/Plugins/SkyrimNet-SlaveTats/Packs/alpia-slavetats.json`, `zaki-general.json`.

## Method

- Text, category and position derive from the SlaveTats JSON names and sections. Textures were not read, except four Alpia torso-side samples to locate the `Left`/`Right` sections.
- Nothing was tested in game.
- `Chest` and `Belly` were added to the position vocabulary for these packs.

## Confidence levels

- high: name states text and placement outright.
- medium: text or placement inferred from a consistent naming pattern.
- low: guessed; check the texture.

## Alpia Slavetats SE

| Confidence | Tattoos |
|---|---|
| medium | 192 |
| low | 73 |
| skipped | 2 |

- Installed sets only: Bondage, Crime, Public Whore 2, Toilet Prison. Beggar, Public Whore and General are not installed.
- No entry is high: Alpia names abbreviate the handwriting, so exact wording is unverified. Short names are medium, names of five or more words low.
- Category is the set name (`bondage`, `crime`, `whore`, `toilet`), not the individual text. Generic insults in the Crime set are therefore `crime`.
- Sections `Alpia Left`/`Alpia Right` sit on the torso sides and map to `Belly`.
- `PW` prefix treated as a set marker and dropped from the text.
- Two full-body tattoos share Section and Name between a face and a body texture; each is listed once.

### By section

| Section | high | medium | low | skipped |
|---|---|---|---|---|
| Alpia Face | 0 | 6 | 1 | 0 |
| Alpia Chest | 0 | 23 | 7 | 0 |
| Alpia Belly | 0 | 23 | 3 | 0 |
| Alpia Back | 0 | 27 | 19 | 0 |
| Alpia Butt | 0 | 16 | 3 | 0 |
| Alpia Arms | 0 | 27 | 3 | 0 |
| Alpia Legs | 0 | 49 | 11 | 0 |
| Alpia Left | 0 | 0 | 12 | 0 |
| Alpia Right | 0 | 0 | 14 | 0 |
| Alpia Full | 0 | 7 | 0 | 0 |
| Alpia FULL | 0 | 14 | 0 | 2 |

### Low entries

**symbols; described from filename only** (5)

Chest / Nipples - Handcuffs; Chest / Nipples - bdsm symbol; Chest / Nipples - R circle L target; Chest / Nipples - R heart L pussy mark; Chest / Nipples - R Pussy mark L egg+sperm

**drawing; described from filename only** (10)

Belly / Lower - D I heart bondage; Belly / Pubic - D love lock; Legs / L Upper Inner - D Plug; Legs / R Upper Inner - D Anal Beads; Legs / L Lower - d Spades Ivy; Legs / R Lower - d Floral; Face / L Eye - d pussy mark (R)dick nose; Chest / Nipples - d R twist + L circle mark; Belly / Pubic - d WC; Butt / Buttcrack - d WC

**filename likely abbreviates the written text** (30)

Back / Middle - Gets stuck in devices on purpose; Back / Middle - Bondage adventure no help allowed; Back / Middle - Dont Free me I want it; Back / Middle - I heart being tied in public; Back / Middle - I picked the wrong keyholder I'm stuck; Back / Middle - I threw my keys away at your mercy; Back / Middle - keep tied I enjoy it; Legs / L Upper Front - if you read this selfbondage gone wrong; Legs / L Upper Front - Help me my holes are empty; Legs / R Upper Front - Push me down and tie me up; Legs / R Upper Back - yes you can fuck me; Back / Upper - crime battery punish by gangrape; Back / Upper - crime whoring serve as cumrag; Back / Upper - Crime whoring serve as fuckdoll; Back / Middle - commit crimes to get raped; Back / Middle - I stole your goods now take mine; Back / Middle - Im a dumb cunt stuff mouth; Back / Middle - Im a fuckdoll use me; Back / Middle - Im criminal I love punishment; Back / Middle - Im your cumrag wipe your dick; Back / Middle - whip me till I piss myself; Legs / L Upper Front - put her in her place; Chest / L Breast - Slap To Turn Me On; Back / Upper - Bend Me Use This Hole; Butt / LBc - PW Fuck Meat Belongs To Town; Butt / RBc - PW Service List Use As U Like; Arms / R Lower - PW Service List Hands For Pleasure; Arms / L Upper - Dedicated To Service Fill Holes; Back / Lower - I heart getting ass raped; Legs / R Upper Front - bath her in cum and piss

**spans both limbs; mapped to All Over** (2)

Legs / R + L - Spread (Knee); Arms / L + R Lower side - keep tied

**torso side mapped to Belly** (24)

Left / Upper - submissive; Left / Lower - keep tied; Left / Lower - Days in Chastity; Right / Upper - rope bunny; Right / Lower - lost her keys; Right / Lower - Days Edged; Right / Upper - struggler; Right / Upper - Bimbo; Right / Upper - Bitch; Right / Upper - cumrag; Right / Lower - heart cock; Right / Lower - make me squeal; Left / Upper - fuckdoll; Left / Upper - Slut; Left / Upper - whore; Left / Lower - break her; Left / Lower - me her regret; Right / R Upper - PW Service List; Right / R Lower - PW Barcode Used to be Hero; Left / L Upper - PW Service List; Left / L Lower - PW Service Tally; Right / Upper - cock wiper; Right / Lower - piss on me; Left / Upper - defiant bitch

**filename likely abbreviates the written text; torso side mapped to Belly** (1)

Right / R Lower - Body No Mercy Only Cock

**meaning taken from filename; torso side mapped to Belly** (1)

Left / Lower - kanji public toilet

### Skipped entries

**duplicate Section/Name in source (face+body pair); kept once** (2)

FULL / Full - Public Whore; FULL / Full - Toilet Prison

### Medium entries

**full-body set; individual texts unknown** (21)

Full / Full - Bondage; Full / Full - Crime Addon; Full / Full - Crime Battery; Full / Full - Crime Defamation; Full / Full - Crime Prisoner; Full / Full - Crime Thief; Full / Full - Crime Whoring; FULL / Full - Public Whore; FULL / Full - Public Whore Addon 2; FULL / Full - Public Whore Addon; FULL / Full - Public Whore With Tramp Stamp Space; FULL / Full - Toilet Prison; FULL / Full - Toilet Public(misc); FULL / Full - Toilet Prison Addon 1 (body); FULL / Full - Toilet Prison Addon 2 (body); FULL / Full - Toilet Prison progressive day 0 (body)(misc); FULL / Full - Toilet Prison progressive day 1 (body)(misc); FULL / Full - Toilet Prison progressive day 3 (body)(misc); FULL / Full - Toilet Prison progressive day 5 (body)(misc); FULL / Full - Toilet Prison progressive day 7 (body)(misc); FULL / Full - Toilet Prison progressive day 14 (body)(misc)

**source area 'Face -' is malformed; SlaveTats may not install it** (2)

Face / Forehead - #1012 (prison); Face / Face - Toi Let

**meaning taken from filename** (3)

Arms / L Upper Back - kanji bottom; Legs / L Upper Inner - kanji holywater (urine); Legs / R Lower Back - kanji human toilet

## Zaki Tattoos General Pack SE

| Confidence | Tattoos |
|---|---|
| high | 674 |
| medium | 101 |
| low | 66 |

- Position is high wherever the section names a region directly.
- Hands: sections `Left`/`Right` use SlaveTats area Hands, mapped to Left/Right Hand.
- Feet and Wrists are assumed to cover both sides and map to `All Over`.
- Shoulder maps to `Back`; front or back is unverified.
- Hip maps to Upper Leg, belly sides to `Belly`.
- Categories come from keywords: `symbol`, `amputation`, `toilet`, `bondage`, `rape`, `slave`, `abuse`; everything else is `slut`. First match wins, so “Piss slave” is `toilet` and “Abuse my holes” is `abuse`.

### By section

| Section | high | medium | low | skipped |
|---|---|---|---|---|
| Zaki General Neck | 51 | 2 | 1 | 0 |
| Zaki General Face | 52 | 20 | 2 | 0 |
| Zaki General Forehead | 50 | 1 | 1 | 0 |
| Zaki General Left | 60 | 0 | 2 | 0 |
| Zaki General Mouth | 27 | 0 | 0 | 0 |
| Zaki General Right | 60 | 0 | 2 | 0 |
| Zaki General Shoulder | 0 | 0 | 24 | 0 |
| Zaki General Feet | 0 | 0 | 15 | 0 |
| Zaki General Full Body | 0 | 0 | 1 | 0 |
| Zaki General Chest | 27 | 3 | 0 | 0 |
| Zaki General Wrists | 0 | 0 | 3 | 0 |
| Zaki General Head | 0 | 0 | 5 | 0 |
| Zaki General Butt | 50 | 2 | 2 | 0 |
| Zaki General Breasts | 42 | 4 | 1 | 0 |
| Zaki General Arms | 62 | 0 | 0 | 0 |
| Zaki General Legs | 79 | 33 | 2 | 0 |
| Zaki General Belly | 60 | 30 | 3 | 0 |
| Zaki General Back | 54 | 6 | 2 | 0 |

### Low entries

**front or back of shoulder unverified** (24)

Shoulder / Abuse Me; Shoulder / Bitch; Shoulder / Break Me; Shoulder / Cum Slut; Shoulder / Dirty Slut; Shoulder / Dumb Slut; Shoulder / Free Fuck; Shoulder / Fuck My Ass; Shoulder / Heart Hollow; Shoulder / Ignore Me If I Say No; Shoulder / Make Me Gape; Shoulder / Make Me Scream; Shoulder / My Name Is Bitch; Shoulder / Obedient; Shoulder / Owned; Shoulder / Piss On Me; Shoulder / Property; Shoulder / Public Toilet; Shoulder / Rape Me; Shoulder / Sex Slave; Shoulder / Sextoy; Shoulder / Slave; Shoulder / Slut; Shoulder / Whore

**both feet assumed; mapped to All Over** (10)

Feet / Abuse My Holes; Feet / Give Me Bruises; Feet / Heart Hollow; Feet / I Always Swallow; Feet / I Love Pain; Feet / Owned; Feet / Rape Me; Feet / Slave; Feet / Slut; Feet / Torture Me

**full-body layout guessed from name** (1)

Full Body / Amputate Full Body

**both feet assumed; mapped to All Over; one phrase per foot assumed** (1)

Feet / Bitch Break Me

**both feet assumed; mapped to All Over; text split across both feet; rest unknown; category guessed from incomplete text** (2)

Feet / Born; Feet / I Love

**both feet assumed; mapped to All Over; split across feet guessed** (1)

Feet / Cum Slut Addict

**both wrists assumed; mapped to All Over** (3)

Wrists / Heart; Wrists / Heart Hollow; Wrists / Slave

**'Head' placement unverified; numbered variant; style difference unverified** (5)

Head / Heart 1; Head / Heart Hollow 1; Head / Heart Hollow 2; Head / Heart Hollow 3; Head / Heart Hollow 4

**both feet assumed; mapped to All Over; text continues beyond filename; rest unknown; category guessed from incomplete text** (1)

Feet / If Im Alone

**text continues beyond filename; rest unknown; category guessed from incomplete text** (9)

Face / If Im Alone; Forehead / If Im Alone; Left / If Im Alone; Right / If Im Alone; Butt / Left - If Im Alone; Legs / Left Lower - If Im Alone; Belly / Pubic - If Im Alone; Belly / Top - If Im Alone; Back / Upper - If Im Alone

**text continues beyond filename; rest unknown** (9)

Neck / If Im Not Screaming; Face / If Im Not Screaming; Left / If Im Not Screaming; Right / If Im Not Screaming; Legs / Left Upper Front - If Im Not Screaming; Belly / Middle - If Im Not Screaming; Back / Middle - If Im Not Screaming; Breasts / Right - If Im Not Screaming; Butt / Right - If Im Not Screaming

### Medium entries

**filename truncated; completed from sibling tattoos** (12)

Neck / Beat The Shit; Face / Beat The Shit; Forehead / Beat The Shit; Chest / Chest - Born To Serve; Chest / Chest - Choke Me Till; Legs / Left Upper Front - Born To Serve; Back / Lower - Born To Serve; Back / Middle - Choke Me Till; Breasts / Right - Choke Me Till; Legs / Right Lower - Choke Me Till; Back / Upper - Born To Serve; Back / Upper - Choke Me Till

**counter assumed from wording** (11)

Chest / Chest - Litres Of Cum Drank; Face / Days Tied Up; Breasts / Left - Days Tied Up; Breasts / Left - Litres Of Cum Drank; Legs / Left Upper Back - Days Tied Up; Neck / Litres Of Cum Drank; Belly / Middle - Litres Of Cum Drank; Belly / Middle - Loads Inside; Butt / Right - Times It Was Consensual; Belly / Top - Days Tied Up; Back / Upper - Days Tied Up

**hip mapped to Upper Leg** (29)

Legs / Left Hip - Beat The Shit Out Of Me; Legs / Left Hip - Cocksleeve; Legs / Left Hip - Fuck Hole; Legs / Left Hip - Fuck Me Till Im Dead; Legs / Left Hip - I Always Swallow; Legs / Left Hip - Ignore Me If I Say No; Legs / Left Hip - Paint Me With Cum; Legs / Left Hip - Slave; Legs / Left Hip - Slave To Cock; Legs / Left Hip - Stretch My Holes; Legs / Left Hip - Whip Me; Legs / Right Hip - Abuse Me; Legs / Right Hip - Born Slave; Legs / Right Hip - Cum Addict; Legs / Right Hip - Cum In My Eyes; Legs / Right Hip - Dirty Slut; Legs / Right Hip - Give Me Bruises; Legs / Right Hip - Horny; Legs / Right Hip - I Can Take On 6 Guys; Legs / Right Hip - I Will Suck You Dry; Legs / Right Hip - Im Forbidden To Say No; Legs / Right Hip - Make Me Cry; Legs / Right Hip - My Name Is Bitch; Legs / Right Hip - Owned; Legs / Right Hip - Piss Slave; Legs / Right Hip - Put Me In My Place; Legs / Right Hip - Sextoy; Legs / Right Hip - Slave; Legs / Right Hip - Will Drop For Cock

**hip mapped to Upper Leg; counter assumed from wording** (1)

Legs / Left Hip - Days Tied Up

**side of torso mapped to Belly** (25)

Belly / Left Side - Anal Only; Belly / Left Side - Battered And Horny; Belly / Left Side - Cum Addict; Belly / Left Side - Cum Dump; Belly / Left Side - Fuck My Ass; Belly / Left Side - Hack My Limbs Off; Belly / Left Side - I Will Drink Your Piss; Belly / Left Side - Make Me Cry; Belly / Left Side - My Name Is Bitch; Belly / Left Side - Piss On Me; Belly / Left Side - Put Me In My Place; Belly / Left Side - Slave; Belly / Left Side - Whore; Belly / Right Side - Beat The Shit Out Of Me; Belly / Right Side - Best On All Fours; Belly / Right Side - Cum Slut; Belly / Right Side - Dominate Me; Belly / Right Side - Ignore Me If I Say No; Belly / Right Side - Make Me Cry; Belly / Right Side - Make Me Shit Blood; Belly / Right Side - No Gag Reflex; Belly / Right Side - Please Rape Me; Belly / Right Side - Slave; Belly / Right Side - Tie Me Up; Belly / Right Side - Use Me

**numbered variant; style difference unverified** (17)

Face / Owned 1; Face / Owned 2; Face / Piss On Me 1; Face / Piss On Me 2; Face / Please Rape Me 1; Face / Please Rape Me 2; Face / Public Toilet 1; Face / Public Toilet 2; Face / Rape Me 1; Face / Rape Me 2; Face / Slave 1; Face / Slave 2; Face / Slave 3; Face / Slut 1; Face / Slut 2; Face / Whore 1; Face / Whore 2

**side of torso mapped to Belly; filename truncated; completed from sibling tattoos** (1)

Belly / Right Side - Born To Serve

