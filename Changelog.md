### v4.9.1
- New “Exceptions” section in Notification settings that lists all your chats with custom notifications.
- Telegram Passport now supports more types of data including translated versions of documents.
- Improved password hashing algorithm to better protect Telegram Passport data.
- Export your chats using the latest version of Telegram Desktop.
- **Telegram FOSS:**
  - BoringSSL master checkout

### v4.9
- Telegram Passport – a unified authorization method for services that require personal identification.
- Store your identity documents and personal data in the Telegram cloud using End-to-End Encryption.
- Instantly share your data with services that require real-world ID (finance, ICOs, etc.).
- For a real-life implementation, see www.ePayments.com/tg – the first electronic payments system to integrate Telegram Passport.
- **Telegram FOSS:**
  - FFmpeg 4.0.2
  - libwebp 1.0.0
  - now using BoringSSL master
  - suggested locations and search are back
  - osmdroid 6.0.2 and https for map tiles
  - various cleanups and fixes

### v4.6c
- **Telegram FOSS:**
  - Don't send photo caption twice #247
  - Zoom set to 4 by default for location sharing
  - Update FFmpeg to 4.0.1

#### v4.8.9 (not released as FOSS version)
- Updated the registration process. If you live in the UK or EU, you must be 16 years or older to use Telegram.
- When signing up for Telegram, you accept our Privacy Policy (telegram.org/privacy).
- You can now stop updating your contacts and delete your synced contacts in Privacy & Security settings.
- If you enabled link previews in Secret Chats, you can now disable them in Privacy & Security settings.

### v4.6b
- **Telegram FOSS:**
  - Allow to set a proxy before login #230
  - Use MS DF 2 PWN RKN. Getting connected to Telegram behind a country-wide block may require you to stare on your login screen for some seconds.
  - Update FFmpeg to 3.4.2
  - Update OpenSSL to 1.0.2o
  - Update SQLite to 3.23.1

#### v4.8.5 (not released as FOSS version)
- Discover new stickers. Type one emoji to see suggestions from popular sticker sets. Suggestions from the sticker sets you've added will come first.
- Search for Stickers. Scroll up in the sticker panel and use the new search field to quickly locate your sticker sets or discover new ones.
- Multi-shot sending. Take and send multiple photos and videos one after another.

#### v4.8.2 (not released as FOSS version)
- Fixed sunrise and sunset time issues for Auto-Night Mode.
- Fixed badge counter for Nova Launcher.
- Fixed round videos recording on some devices.

#### v4.8 (not released as FOSS version)
- Streaming for videos. Start watching any newly uploaded video instantly without having to fully download it first.
- Auto-Night Mode. Automatically switch to the dark version of the interface after nightfall or in low-light conditions.
- Telegram Login widget. Log in to other websites and services using your Telegram account.

#### v4.7 (not released as FOSS version)
- Quickly switch between different Telegram accounts if you use multiple phone numbers.
- Swipe left on any message to reply to it.

### v4.6a
- **Telegram FOSS:**
  - version bump to rebuild with NDK r14b
  - fixes unsupported content for url sharing #200

### v4.6
- New granular settings for auto-downloading media.
- Link previews for Instagram posts and tweets with multiple photos will now show all the media as an album.
- Embeddable HTML-widget for messages in public channels and groups (available when viewing t.me links to messages in web-browsers).
- Added support for albums to Secret Chats.
- Added full support for MTProto 2.0.
- **Telegram FOSS:**
  - emojiOne replaced with Twemoji

### v4.2.1b
- **Telegram FOSS:**
  - update OpenSSL to 1.0.2n
  - fix videos without sound
  - fix image sharing bug (sorry for that one!)

### v4.2.1a
- **Telegram FOSS:**
  - **SECURITY:** update OpenSSL to 1.0.2m
  - **SECURITY:** update FFmpeg to 3.4
  - **SECURITY:** update SQLite and libWebP to latest versions.
  - Build native code for armv6 devices
  - Dropped the unused Google Breakpad library
  - Can and should now be built with NDK r15c
  - Added location sharing through "geo:" intents

#### v4.5 (not released as FOSS version)
- Grouped Photos. Group media into albums when sharing multiple photos and videos. Choose the exact order of media you send.
- Saved Messages. Bookmark messages by forwarding them to “Saved Messages”.
- Better Search. Find bots and public channels faster by typing their titles in Search. Popular bots and channels are shown first.
- Pinned Messages. Pin messages in your channels to make important announcements more visible.

#### v4.4 (not released as FOSS version)
- Share your location with friends in real time with the new Live Locations.
- Control whether new members in supergroups can see earlier message history.
- Easily recognize messages from group admins by the new ‘admin’ badge.
- Listen to audio files with more comfort using the redesigned player.
- Added French, Malay, Indonesian, Russian, and Ukrainian languages.
- Suggest alternative translations using our new localization platform – translations.telegram.org

#### v4.3 (not released as FOSS version)
- Groups with unread mentions and replies are now marked with an '@' badge in the chats list.
- Navigate new mentions and replies in a group using the new '@' button.
- Mark stickers as Favorite to quickly access them from the redesigned sticker panel.
- Invite friends to Telegram using the new streamlined interface.
- Add an official sticker set for your group to be used by all members without adding (100+ member groups only).
- Numerous design and UI improvements.

#### v4.2.2 (not released as FOSS version)
- Add emoji to a message by typing ‘:’ + keyword. :relieved : :satisfied : :smirk :
- Search through messages of a particular user in any group. To do this, tap '...' in the top right corner when in a group > Search > tap the new 'Search by member' icon in the bottom right corner.
- While searching, select a user to browse all of her messages in the group or add a keyword to narrow down search results.

### v4.2.1
- Send self-destructing photos and videos to any one-on-one chats (use the clock icon in the media picker to set a timer).
- Edit photos even quicker with the improved photo editor.
- Add a bio to your profile (in Settings) so that people in large group chats know who you are.
- Download media from large public channels faster thanks to the new encrypted CDNs.
- When choosing a sticker, tap the "up" button in the sticker panel to expand it to full screen.

### v4.1.1
- Improved voice calls, bug fixes.
- **Telegram FOSS:**
  - Revert Russian and Czech translations(closer to upstream, xmls are always outdated)
  - Payments code restored, cleaned from binaries and might be working(not tested, please report)

#### v4.1.0 (not released as FOSS version)
- Up to 10.000 members in each supergroup.
- Granular rights for supergroup admins.
- Granular restrictions and temporary bans for members.
- Event log: all service actions taken by members and admins in the last 48 hours – with search and filters.
- Admins can now search for specific users among group and channel members.

#### v4.0 (not released as FOSS version)
- Video messages. Tap the mic icon to switch to camera mode, then tap and hold to record stylish video messages. Swipe up while recording for hands free mode (works with voice notes).
- Meet Telesco.pe, where anyone can view video messages from public channels — no Telegram account required.
- Bots can now accept payments from users.
- The Instant View Platform is now public and will soon support thousands of websites, including your favorite ones.

#### v3.18.1 (not released as FOSS version)
- Voice calls are now available in Europe, Africa, North and South Americas.

### v3.18.0c
- **Telegram FOSS:**
  - Telegram-FOSS won't suggest to update from Google Play
  - The location pin is now accurate (#155)

### v3.18.0b
- **Telegram FOSS:**
  - Add OpenStreetMap attribution (#151)
  - Include Russian and Czech translation xmls

### v3.18.0a
- **Telegram FOSS:**
  - Fix location sharing on SDK < 23

### v3.18.0
- Telegram Calls are here: secure, crystal-clear, constantly improved by artificial intelligence. We are rolling them out in Europe today, the rest of the world will get calls within a few days.
- Choose between 5 grades of video compression and preview the quality of your video before you send it.
- **Telegram FOSS:**
  - Update to openssl 1.0.2k
  - Restore SMS receiving functionality: reviewed, harmless
  - Restore Giphy search
  - Add [osmdroid](https://github.com/osmdroid/osmdroid) for location messages support

#### v3.17.0 (not released as FOSS version)
- Use custom themes to change the appearance of the app.
- Check out the new dark theme in Settings > Themes. See the @themes channel for more ideas.
- Create your own themes using the new built-in editor.

#### v3.16.0 (not released as FOSS version)
- Delete recently sent messages for everyone.
- Network Usage in 'Data and Storage' Settings.
- App remembers scroll position when switching to another chat and back.
- Messages from one sender are grouped together.
- Added a floating date to the top of the screen when scrolling.
- Recently downloaded files are shown when sharing a file.
- Report spam from Secret chats.
- Send GIFs directly from Gboard.
- Android 7.1: Added fast action menu to home screen.

#### v3.15.0 (not released as FOSS version)
- Pin important chats to the top of the list so that you never miss a new message.
- Link your Telegram account with hundreds of services like Twitter, Instagram, Spotify, Gmail, and others. Control apps via Telegram, or get messages when something happens. Talk to @IFTTT to set up.
- Rotate photos by any number of degrees in the photo editor.
- View YouTube and Vimeo in Picture-in-Picture mode.

#### v3.14.0 (not released as FOSS version)
- Instant View for Medium articles and some other sites. No more waiting for the pages to load!
- ‘Groups in common’ in user profiles.
- ‘Jump to date’ in message search.
- 'View Pack' for recent stickers.
- Setting a passcode now hides your chats from the task-switcher.
- Improved camera speed, video compression.
- Improved interfaces.
- Also introducing telegra.ph, a new publishing platform. You can now use telegra.ph to publish articles – it’s clean, simple and efficient.

#### v3.13.2 (not released as FOSS version)
- Major update to Telegram's Bot Platform: Bots can now offer you rich HTML5 experiences, like games.
- Check out @gamebot for examples of what's coming.
- You can use these bots in inline mode in any of your chats to share a game and compete with friends.
- All games are loaded as ordinary web pages, so this update won't add a single byte to the size of our apps.
- Added many small improvements to the sticker panel.

### v3.13.1
- Major update to Telegram's Bot Platform: Bots can now offer you rich HTML5 experiences, like games.
- Check out @gamebot for examples of what's coming.
- You can use these bots in inline mode in any of your chats to share a game and compete with friends.
- All games are loaded as ordinary web pages, so this update won't add a single byte to the size of our apps.
- Added many small improvements to the sticker panel.
- **Telegram FOSS:**
  - Use emojiOne emoji set as a free replacement for Telegrams emoji.

#### v3.12 (not released as FOSS version)
- Draw on your photos and apply stylish masks, stickers, and text. We're launching a platform for masks today; anyone can upload their own sets of masks, beards, glasses, and the like.
- Create your own GIFs using the new "mute" feature after you record a video.
- Access trending stickers directly from the stickers panel in any of your chats.
- Added support for Android 7.0.

#### v3.11 (not released as FOSS version)
- Trending stickers. Install noteworthy sets from the new tab in Settings.
- Unused stickers archived automatically when you go over the 200 limit.
- Group previews. Preview groups via invite link – see who else is in the group before joining.
- Personal storage. Keep messages, media and any other stuff in the new storage chat with yourself.
- New improved camera interface (4.1+)
- Preview bot content before sending (4.1+)
- Download large media and files 2-4x times faster.

### v3.10.1
- DRAFTS AND MORE
- Introducing Drafts: Seamless syncing for unsent messages on all your devices. Drafts are now visible in your chats list.
- New internal video player (Android 4.1 and above).
- Unread messages counter on the 'Scroll to bottom' button.
- View earlier profile pictures in groups.
- More about this update: https://telegram.org/blog/drafts
- **Telegram FOSS:**
  - Bots can ask for accessing your location now, we therefore include the corresponding Android permission. This is opt-in behaviour.

#### v3.9.0 (not released as FOSS version)
- Edit your messages everywhere within 2 days after posting.
- Mention people in groups by typing @ and selecting them from the list — even if they don't have a username.
- Get to your friends faster with the new People list in Search.
- Find inline bot shortcuts in the attachment menu.
- Add chat shortcuts to home screen.

#### v3.8.1 (not released as FOSS version)
- Fully redesigned chat screens, optimized colors, beautiful progress bars, revamped attachments.
- Tap on any sticker to view its pack and add it to your collection. Preview and send stickers from the pack preview menu.
- Introducing Bot API 2.0, the biggest update to our bot platform since June 2015. Try out these sample bots to see what's coming your way soon: @music, @sticker, @youtube, @foursquare

### v3.7.0
- PUBLIC GROUPS, PINNED POSTS, 5,000 MEMBERS
- Groups can now have 5,000 members (up from 1,000)
- Groups of any size may be converted to supergroups
- New tools for supergroup admins:
- Make your group public by setting up a public link – anyone will be able to view the chat and join it
- Pin messages to keep important updates visible and notify all members
- Select messages to delete, report as spam, block users, or remove all messages from a user

### v3.6.1a
- **Telegram FOSS:**
  - Fix emoji not displaying in chat window

### v3.6.1
- Bug fixes

### v3.6.0
- Edit messages in channels and supergroups.
- Share links for posts in channels (in the Quick Share menu).
- Option to add admin signatures to messages in channels.
- Silent messages in channels that will not notify members.
- Quick Share button for bots (works for messages with links, photos or videos).
- Tap and hold to view stickers in full size without sending. Now works everywhere, including emoji suggestions and the 'Add stickers' screen.

### v3.5.1
- Raise to speak fixes

### v3.5.0
- New Voice Messages
- Waveform visualizations, brand new player. Experimental: raise to speak / raise to listen
- New Secret Chats
- Support for all the stuff you love in cloud chats: GIFs, replies, sticker set previews, and inline bots. Added improved key visualization and optional link previews
- New privacy settings
- Control who can add you to groups and channels with granular precision
- New photo editor. Added rotate, fade, tint and curves tools
- **Telegram FOSS:**
  - Don't set network alarm if there's no network connection.
  - Upgrade to openssl-1.0.1s.
  - Fix always clearing recent emojis.
  - Fix Location Parsing. Now works on non-english languages.
