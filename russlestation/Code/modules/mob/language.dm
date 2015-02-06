/*
	Datum based languages. Easily editable and modular.
*/

/datum/language
	var/name = "an unknown language" // Fluff name of language if any.
	var/desc = "A language."         // Short description for 'Check Languages'.
	var/speech_verb = "says"         // 'says', 'hisses', 'farts'.
	var/colour = "body"         // CSS style to use for strings in this language.
	var/key = "x"                    // Character used to speak in language eg. :o for Unathi.
	var/flags = 0                    // Various language flags.
	var/native                       // If set, non-native speakers will have trouble speaking.
	var/whisp = "whispers"						//for whispers

/datum/language/unathi
	name = "Sinta'unathi"
	desc = "The common language of Moghes, composed of sibilant hisses and rattles. Spoken natively by Unathi."
	speech_verb = "hisses"
	colour = "soghun"
	key = "o"
	whisp = "hisses quietly"
	flags = RESTRICTED

/datum/language/tajaran
	name = "Siik'tajr"
	desc = "An expressive language that combines yowls and chirps with posture, tail and ears. Native to the Tajaran."
	speech_verb = "mrowls"
	colour = "tajaran"
	key = "j"
	whisp = "mews softly"
	flags = RESTRICTED

/datum/language/vulpix
	name = "Vulpix"
	desc = "A language."
	speech_verb = "yips"
	colour = "vulpix"
	key = "H"
	whisp = "yips softly"
	flags = RESTRICTED

/datum/language/Aviskree
	name = "Aviachirp"
	desc = "An expressive language is very beautiful execpt when you want to sleep."
	speech_verb = "chirps"
	colour = "Aviskree"
	whisp = "chirps quietly"
	key = "y"
	flags = RESTRICTED

/datum/language/skrell
	name = "Skrellian"
	desc = "A melodic and complex language spoken by the Skrell of Qerrbalak. Some of the notes are inaudible to humans."
	speech_verb = "warbles"
	colour = "skrell"
	whisp = "warbles quitely"
	key = "k"
	flags = RESTRICTED

/datum/language/vox
	name = "Vox-pidgin"
	desc = "The common tongue of the various Vox ships making up the Shoal. It sounds like chaotic shrieking to everyone else."
	speech_verb = "shrieks"
	colour = "vox"
	whisp = "shreiks under their breath"
	key = "v"
	flags = RESTRICTED

/datum/language/diona
	name = "Rootspeak"
	desc = "A creaking, subvocal language spoken instinctively by the Dionaea. Due to the unique makeup of the average Diona, a phrase of Rootspeak can be a combination of anywhere from one to twelve individual voices and notes."
	speech_verb = "creaks and rustles"
	colour = "soghun"
	whisp = "quitely creaks and rustles"
	key = "q"
	flags = RESTRICTED

/datum/language/human
	name = "Sol Common"
	desc = "A bastardized hybrid of informal English and elements of Mandarin Chinese; the common language of the Sol system."
	colour = "rough"
	key = "1"
	flags = RESTRICTED

// Galactic common languages (systemwide accepted standards).
/datum/language/trader
	name = "Tradeband"
	desc = "Maintained by the various trading cartels in major systems, this elegant, structured language is used for bartering and bargaining."
	speech_verb = "enunciates"
	whisp="whispers in an elegant tone"
	colour = "say_quote"
	key = "2"

/datum/language/gutter
	name = "Gutter"
	desc = "Much like Standard, this crude pidgin tongue descended from numerous languages and serves as Tradeband for criminal elements."
	speech_verb = "growls"
	whisp ="growls softly"
	colour = "rough"
	key = "3"

/datum/language/Chittin
	name = "Chittin"
	desc = "very silent almost telepath speech."
	speech_verb = "chirps and hums"
	whisp = "hums softly"
	colour = "Chittin"
	key = "4"
	flags = RESTRICTED

/datum/language/Chimp
	name = "Washoe"
	desc = "A form of monkey sign language."
	speech_verb = "signs"
	whisp = "makes subtle signs"
	colour = "Washoe"
	key = "6"
	flags = RESTRICTED

/datum/language/Machine
	name = "Encoded Audio Language"
	desc = "A fast paced array of beeps and buzzes."
	speech_verb = "beeps"
	whisp = "softly beeps"
	colour = "machine"
	key = "p"
	flags = RESTRICTED

// Language handling.
/mob/proc/add_language(var/language)

	var/datum/language/new_language = all_languages[language]

	if(!istype(new_language) || new_language in languages)
		return 0

	languages.Add(new_language)
	return 1

/mob/proc/remove_language(var/rem_language)

	languages.Remove(all_languages[rem_language])

	return 0

//TBD
/mob/verb/check_languages()
	set name = "Check Known Languages"
	set category = "IC"
	set src = usr

	var/dat = "<b><font size = 5>Known Languages</font></b><br/><br/>"

	for(var/datum/language/L in languages)
		dat += "<b>[L.name] (:[L.key])</b><br/>[L.desc]<br/><br/>"

	src << browse(dat, "window=checklanguage")
	return