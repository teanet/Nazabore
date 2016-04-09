#import "NZBEmojiSelectVM.h"

#import "NZBEmojiCell.h"

@interface NZBEmojiSelectVM ()

@property (nonatomic, copy, readonly) NSArray<NZBEmojiPageVM *> *pages;

@end

@implementation NZBEmojiSelectVM

- (instancetype)init
{
	self = [super init];
	if (self == nil) return nil;

	NSArray<NZBEmojiCategory *> *sections = [NZBEmojiSelectVM cachedSections];
	NSMutableArray *pages = [NSMutableArray arrayWithObject:[NZBEmojiPageVM defaultVM]];
	[sections enumerateObjectsUsingBlock:^(NZBEmojiCategory *category, NSUInteger _, BOOL *stop) {
		[pages addObject:[[NZBEmojiPageVM alloc] initWithCategory:category]];
	}];

	_didSelectEmojiSignal = [[RACSignal merge:[pages.rac_sequence map:^RACSignal *(NZBEmojiPageVM *page) {
		return page.didSelectEmojiSignal;
	}].array] take:1];
	_pages = [pages copy];
	_pagesCount = pages.count;
	_currentPageIndex = 0;
	return self;
}

- (void)selectRandomEmoji
{
	[self.currentPageVM selectRandomEmoji];
}

- (void)setCurrentPageIndex:(NSInteger)currentPageIndex
{
	if (currentPageIndex < 0 || currentPageIndex >= self.pagesCount) return;
	_currentPageIndex = currentPageIndex;
}

- (NZBEmojiPageVM *)currentPageVM
{
	return self.pages[self.currentPageIndex];
}

- (NZBEmojiPageVM *)pageAfterPage:(NZBEmojiPageVM *)pageVM
{
	NSInteger pageIndex = [self indexOfPage:pageVM];
	if (pageIndex != NSNotFound)
	{
		NSInteger nextIndex = (pageIndex + 1) % self.pagesCount;
		return [self pageAtIndex:nextIndex];
	}
	return nil;
}

- (NZBEmojiPageVM *)pageBeforePage:(NZBEmojiPageVM *)pageVM
{
	NSInteger pageIndex = [self indexOfPage:pageVM];
	if (pageIndex != NSNotFound)
	{
		NSInteger ppIndex = (self.pagesCount + pageIndex - 1) % self.pagesCount;
		return [self pageAtIndex:ppIndex];
	}
	return nil;
}

- (NZBEmojiPageVM *)pageAtIndex:(NSInteger)index
{
	if (index == NSNotFound || index < 0 || index >= self.pagesCount) return nil;
	return self.pages[index];
}

- (NSUInteger)indexOfPage:(NZBEmojiPageVM *)pageVM
{
	return [self.pages indexOfObject:pageVM];
}

+ (NSArray<NZBEmojiCategory *> *)cachedSections
{
	static NSArray<NZBEmojiCategory *> *cachedSections = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		NZBEmojiCategory *c1 = [[NZBEmojiCategory alloc] initWithTitle:@"1" text:@"😀 😬 😁 😂 😃 😄 😅 😆 😇 😉 😊 🙂 🙃 ☺️ 😋 😌 😍 😘 😗 😙 😚 😜 😝 😛 🤑 🤓 😎 🤗 😏 😶 😐 😑 😒 🙄 🤔 😳 😞 😟 😠 😡 😔 😕 🙁 ☹️ 😣 😖 😫 😩 😤 😮 😱 😨 😰 😯 😦 😧 😢 😥 😪 😓 😭 😵 😲 🤐 😷 🤒 🤕 😴 💤 💩 😈 👿 👹 👺 💀 👻 👽 🤖 😺 😸 😹 😻 😼 😽 🙀 😿 😾 🙌 👏 👋 👍 👊 ✊ ✌️ 👌 ✋ 💪 🙏 ☝️ 👆 👇 👈 👉 🖕 🤘 🖖 ✍️ 💅 👄 👅 👂 👃 👁 👀 👤 🗣 👶 👦 👧 👨 👩 👱 👴 👵 👲 👳 👮 👷 💂 🕵 🎅 👼 👸 👰 🚶 🏃 💃 👯 👫 👭 🙇 💁 🙅 🙆 🙋 🙎 🙍 💇 💆 💑 💏 👪 👨‍👩‍👧 👨‍👩‍👧‍👦 👨‍👩‍👦‍👦 👨‍👩‍👧‍👧 👩‍👩‍👦 👚 👕 👖 👔 👗 👙 👘 💄 💋 👣 👠 👡 👢 👞 👟 👒 🎩 ⛑ 🎓 👑 🎒 👝 👛 👜 💼 👓🕶💍🌂"];
		NZBEmojiCategory *c2 = [[NZBEmojiCategory alloc] initWithTitle:@"1" text:@"👦🏻 👧🏻 👨🏻 👩🏻 👴🏻 👵🏻 👶🏻 👱🏻 👮🏻 👲🏻 👳🏻 👷🏻 👸🏻 💂🏻 🎅🏻 👼🏻 💆🏻 💇🏻 👰🏻 🙍🏻 🙎🏻 🙅🏻 🙆🏻 💁🏻 🙋🏻 🙇🏻 🙌🏻 🙏🏻 🚶🏻 🏃🏻 💃🏻 💪🏻 👈🏻 👉🏻 ☝️🏻 👆🏻 🖕🏻 👇🏻 ✌️🏻 🖖🏻 🤘🏻 🖐🏻 ✊🏻 ✋🏻 👊🏻 👌🏻 👍🏻 👎🏻 👋🏻 👏🏻 👐🏻 ✍🏻 💅🏻 👂🏻 👃🏻 🚣🏻 🛀🏻 🏄🏻 🏇🏻 🏊🏻 ⛹🏻 🏋🏻 🚴🏻 🚵🏻"];
		NZBEmojiCategory *c3 = [[NZBEmojiCategory alloc] initWithTitle:@"1" text:@"🐶 🐱 🐭 🐹 🐰 🐻 🐼 🐨 🐯 🦁 🐮 🐷 🐽 🐸 🐙 🐵 🙈 🙉 🙊 🐒 🐔 🐧 🐦 🐤 🐣 🐥 🐺 🐗 🐴 🦄 🐝 🐛 🐌 🐞 🐜 🕷 🦂 🦀 🐍 🐢 🐠 🐟 🐡 🐬 🐳 🐋 🐊 🐆 🐅 🐃 🐂 🐄 🐪 🐫 🐘 🐐 🐏 🐑 🐎 🐖 🐀 🐁 🐓 🦃 🕊 🐕 🐩 🐈 🐇 🐿 🐾 🐉 🐲 🌵 🎄 🌲 🌳 🌴 🌱 🌿 ☘ 🍀 🎍 🎋 🍃 🍂 🍁 🌾 🌺 🌻 🌹 🌷 🌼 🌸 💐 🍄 🌰 🎃 🐚 🕸 🌎 🌍 🌏 🌕 🌖 🌗 🌘 🌑 🌒 🌓 🌔 🌚 🌝 🌛 🌜 🌞 🌙 ⭐️ 🌟 💫 ✨ ☄ ☀️ 🌤 ⛅️ 🌥 🌦 ☁️ 🌧 ⛈ 🌩 ⚡️ 🔥 💥 ❄️ 🌨 🔥 💥 ❄️ 🌨 ☃️ ⛄️ 🌬 💨 🌪 🌫 ☂️ ☔️ 💧 💦 🌊"];
		NZBEmojiCategory *c4 = [[NZBEmojiCategory alloc] initWithTitle:@"1" text:@"🍏 🍎 🍐 🍊 🍋 🍌 🍉 🍇 🍓 🍈 🍒 🍑 🍍 🍅 🍆 🌶 🌽 🍠 🍯 🍞 🧀 🍗 🍖 🍤 🍳 🍔 🍟 🌭 🍕 🍝 🌮 🌯 🍜 🍲 🍥 🍣 🍱 🍛 🍙 🍚 🍘 🍢 🍡 🍧 🍨 🍦 🍰 🎂 🍮 🍬 🍭 🍫 🍿 🍩 🍪 🍺 🍻 🍷 🍸 🍹 🍾 🍶 🍵 ☕️ 🍼 🍴 🍽"];
		NZBEmojiCategory *c5 = [[NZBEmojiCategory alloc] initWithTitle:@"1" text:@"⚽️ 🏀 🏈 ⚾️ 🎾 🏐 🏉 🎱 ⛳️ 🏌 🏓 🏸 🏒 🏑 🏏 🎿 ⛷ 🏂 ⛸ 🏹 🎣 🚣 🏊 🏄 🛀 ⛹ 🏋 🚴 🚵 🏇 🕴 🏆 🎽 🏅 🎖 🎗 🏵 🎫 🎟 🎭 🎨 🎪 🎤 🎧 🎼 🎹 🎷 🎺 🎸 🎻 🎬 🎮 👾 🎯 🎲 🎰 🎳"];
		NZBEmojiCategory *c6 = [[NZBEmojiCategory alloc] initWithTitle:@"1" text:@"🚗 🚕 🚙 🚌 🚎 🏎 🚓 🚑 🚒 🚐 🚚 🚛 🚜 🏍 🚲 🚨 🚔 🚍 🚘 🚖 🚡 🚠 🚟 🚃 🚋 🚝 🚄 🚅 🚈 🚞 🚂 🚆 🚇 🚊 🚉 🚁 🛩 ✈️ 🛫 🛬 ⛵️ 🛥 🚤 ⛴ 🛳 🚀 🛰 💺 ⚓️ 🚧 ⛽️ 🚏 🚦 🚥 🏁 🚢 🎡 🎢 🎠 🏗 🌁 🗼 🏭 ⛲️ 🎑 ⛰ 🏔 🗻 🌋 🗾 🏕 ⛺️ 🏞 🛣 🛤 🌅 🌄 🏜 🏖 🏝 🌇 🌆 🏙 🌃 🌉 🌌 🌠 🎇 🎆 🌈 🏘 🏰 🏯 🏟 🗽 🏠 🏡 🏚 🏢 🏬 🏣 🏤 🏥 🏦 🏨 🏪 🏫 🏩 💒 🏛 ⛪️ 🕌 🕍 🕋 ⛩"];
		NZBEmojiCategory *c7 = [[NZBEmojiCategory alloc] initWithTitle:@"1" text:@"⌚️ 📱 📲 💻 ⌨ 🖥 🖨 🖱 🖲 🕹 🗜 💽 💾 💿 📀 📼 📷 📸 📹 🎥 📽 🎞 📞 ☎️ 📟 📠 📺 📻 🎙 🎚 🎛 ⏱ ⏲ ⏰ 🕰 ⏳ ⌛️ 📡 🔋 🔌 💡 🔦 🕯 🗑 🛢 💸 💵 💴 💶 💷 💰 💳 💎 ⚖ 🔧 🔨 ⚒ 🛠 ⛏ 🔩 ⚙ ⛓ 🔫 💣 🔪 🗡 ⚔ 🛡 🚬 ☠ ⚰ ⚱ 🏺 🔮 📿 💈 ⚗ 🔭 🔬 🕳 💊 💉 🌡 🏷 🔖 🚽 🚿 🛁 🔑 🗝 🛋 🛌 🛏 🚪 🛎 🖼 🗺 ⛱ 🗿 🛍 🎈 🎏 🎀 🎁 🎊 🎉 🎎 🎐 🎌 🏮 ✉️ 📩 📨 📧 💌 📮 📪 📫 📬 📭 📦 📯 📥 📤 📜 📃 📑 📊 📈 📉 📄 📅 📆 🗓 📇 🗃 🗳 🗄 📋 🗒 📁 📂 🗂 🗞 📰 📓 📕 📗 📘 📙 📔 📒 📚 📖 🔗 📎 🖇 ✂️ 📐 📏 📌 📍 🚩 🏳 🏴 🔐 🔒 🔓 🔏 🖊 🖊 🖋 ✒️ 📝 ✏️ 🖍 🖌 🔍 🔎"];
		NZBEmojiCategory *c8 = [[NZBEmojiCategory alloc] initWithTitle:@"1" text:@"❤️ 💛 💙 💜 💔 ❣️ 💕 💞 💓 💗 💖 💘 💝 💟 ☮ ✝️ ☪ 🕉 ☸ ✡️ 🔯 🕎 ☯️ ☦ 🛐 ⛎ ♈️ ♉️ ♊️ ♋️ ♌️ ♍️ ♎️ ♏️ ♐️ ♑️ ♒️ ♓️ 🆔 ⚛ 🈳 🈹 ☢ ☣ 📴 📳 🈶 🈚️ 🈸 🈺 🈷️ ✴️ 🆚 🉑 💮 🉐 ㊙️ ㊗️ 🈴 🈵 🈲 🅰️ 🅱️ 🆎 🆑 🅾️ 🆘 ⛔️ 📛 🚫 ❌ ⭕️ 💢 ♨️ 🚷 🚯 🚳 🚱 🔞 📵 ❗️ ❕ ❓ ❔ ‼️ ⁉️ 💯 🔅 🔆 🔱 ⚜ 〽️ ⚠️ 🚸 🔰 ♻️ 🈯️ 💹 ❇️ ✳️ ❎ ✅ 💠 🌀 ➿ 🌐 Ⓜ️ 🏧 🈂️ 🛂 🛃 🛄 🛅 ♿️ 🚭 🚾 🅿️ 🚰 🚹 🚺 🚼 🚻 🚮 🎦 📶 🈁 🆖 🆗 🆙 🆒 🆕 🆓 0️⃣ 1️⃣ 2️⃣ 3️⃣ 4️⃣ 5️⃣ 6️⃣ 7️⃣ 8️⃣ 9️⃣ 🔟 🔢 ▶️ ⏸ ⏯ ⏹ ⏺ ⏭ ⏮ ⏩ ⏪ 🔀 🔁 🔂 ◀️ 🔼 🔽 ⏫ ⏬ ➡️ ⬅️ ⬆️ ⬇️ ↗️ ↘️ ↙️ ↖️ ↕️ ↔️ 🔄 ↪️ ↩️ ⤴️ ⤵️ #️⃣ *️⃣ ℹ️ 🔤 🔡 🔠 🔣 🎵 🎶 〰️ ➰ ✔️ 🔃 ➕ ➖ ➗ ✖️ 💲 💱 ©️ ®️ ™️ 🔚 🔙 🔛 🔝 🔜 ☑️ 🔘 ⚪️ ⚫️ 🔴 🔵 🔸 🔹 🔶 🔷 🔺 ▪️ ▫️ ⬛️ ⬜️ 🔻 ◼️ ◻️ ◾️ ◽️ 🔲 🔳 🔈 🔉 🔊 🔇 📣 📢 🔔 🔕 🃏 🀄️ ♠️ ♣️ ♥️ ♦️ 🎴 👁‍🗨 💭 🗯 💬 🕐 🕑 🕒 🕓 🕔 🕕 🕖 🕗 🕘 🕙 🕚 🕛 🕜 🕝 🕞 🕟 🕠 🕡 🕢 🕣 🕤 🕥 🕦 🕧"];
		NZBEmojiCategory *c9 = [[NZBEmojiCategory alloc] initWithTitle:@"1" text:@"🇦🇫 🇦🇽 🇦🇱 🇩🇿 🇦🇸 🇦🇩 🇦🇴 🇦🇮 🇦🇶 🇦🇬 🇦🇷 🇦🇲 🇦🇼 🇦🇺 🇦🇹 🇦🇿 🇧🇸 🇧🇭 🇧🇩 🇧🇧 🇧🇾 🇧🇪 🇧🇿 🇧🇯 🇧🇲 🇧🇹 🇧🇴 🇧🇶 🇧🇦 🇧🇼 🇧🇷 🇮🇴 🇻🇬 🇧🇳 🇧🇬 🇧🇫 🇧🇮 🇨🇻 🇰🇭 🇨🇲 🇨🇦 🇮🇨 🇰🇾 🇨🇫 🇹🇩 🇨🇱 🇨🇳 🇨🇽 🇨🇨 🇨🇴 🇰🇲 🇨🇬 🇨🇩 🇨🇰 🇨🇷 🇭🇷 🇨🇺 🇨🇼 🇨🇾 🇨🇿 🇩🇰 🇩🇯 🇩🇲 🇩🇴 🇪🇨 🇪🇬 🇸🇻 🇬🇶 🇪🇷 🇪🇪 🇪🇹 🇪🇺 🇫🇰 🇫🇴 🇫🇯 🇫🇮 🇫🇷 🇬🇫 🇵🇫 🇹🇫 🇬🇦 🇬🇲 🇬🇪 🇩🇪 🇬🇭 🇬🇮 🇬🇷 🇬🇱 🇬🇩 🇬🇵 🇬🇺 🇬🇹 🇬🇬 🇬🇳 🇬🇼 🇬🇾 🇭🇹 🇭🇳 🇭🇰 🇭🇺 🇮🇸 🇮🇳 🇮🇩 🇮🇷 🇮🇶 🇮🇪 🇮🇲 🇮🇱 🇮🇹 🇨🇮 🇯🇲 🇯🇵 🇯🇪 🇯🇴 🇰🇿 🇰🇪 🇰🇮 🇽🇰 🇰🇼 🇰🇬 🇱🇦 🇱🇻 🇱🇧 🇱🇸 🇱🇷 🇱🇾 🇱🇮 🇱🇹 🇱🇺 🇲🇴 🇲🇰 🇲🇬 🇲🇼 🇲🇾 🇲🇻 🇲🇱 🇲🇹 🇲🇭 🇲🇶 🇲🇷 🇲🇺 🇾🇹 🇲🇽 🇫🇲 🇲🇩 🇲🇨 🇲🇳 🇲🇪 🇲🇸 🇲🇦 🇲🇿 🇲🇲 🇳🇦 🇳🇷 🇳🇵 🇳🇱 🇳🇨 🇳🇿 🇳🇮 🇳🇪 🇳🇬 🇳🇺 🇳🇫 🇲🇵 🇰🇵 🇳🇴 🇴🇲 🇵🇰 🇵🇼 🇵🇸 🇵🇦 🇵🇬 🇵🇾 🇵🇪 🇵🇭 🇵🇳 🇵🇱 🇵🇹 🇵🇷 🇶🇦 🇷🇪 🇷🇴 🇷🇺 🇷🇼 🇧🇱 🇸🇭 🇰🇳 🇱🇨 🇵🇲 🇻🇨 🇼🇸 🇸🇲 🇸🇹 🇸🇦 🇸🇳 🇷🇸 🇸🇨 🇸🇱 🇸🇬 🇸🇽 🇸🇰 🇸🇮 🇸🇧 🇸🇴 🇿🇦 🇬🇸 🇰🇷 🇸🇸 🇪🇸 🇱🇰 🇸🇩 🇸🇷 🇸🇿 🇸🇪 🇨🇭 🇸🇾 🇹🇼 🇹🇯 🇹🇿 🇹🇭 🇹🇱 🇹🇬 🇹🇰 🇹🇴 🇹🇹 🇹🇳 🇹🇷 🇹🇲 🇹🇨 🇹🇻 🇺🇬 🇺🇦 🇦🇪 🇬🇧 🇺🇸 🇻🇮 🇺🇾 🇺🇿 🇻🇺 🇻🇦 🇻🇪 🇻🇳 🇼🇫 🇪🇭 🇾🇪 🇿🇲 🇿🇼"];
		cachedSections = @[ c1, c2, c3, c4, c5, c6, c7, c8, c9 ];
	});
	return cachedSections;
}

@end
