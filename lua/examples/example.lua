require( "localify" )



--[[--------------------------------------------------------------------------
--	Bind examples
--------------------------------------------------------------------------]]--

-- English
localify.Bind( "en",    "Fruit_Banana", "Banana" )
localify.Bind( "en",    "Fruit_Apple",  "Apple" )
-- Spanish
localify.Bind( "es",    "Fruit_Banana", "Manzana" )
localify.Bind( "es",    "Fruit_Apple",  "Plátano" )
-- Swedish
localify.Bind( "sv-SE", "Fruit_Banana", "Banan" )
localify.Bind( "sv-SE", "Fruit_Apple",  "Äpple" )
-- French
localify.Bind( "fr",    "Fruit_Banana", "Banane" )
localify.Bind( "fr",    "Fruit_Apple",  "Pomme"  )



--[[--------------------------------------------------------------------------
--	Localize examples
--------------------------------------------------------------------------]]--

print( localify.Localize( "Fruit_Banana" ) )
-- "Banana"  if gmod_language is "en"
-- "Manzana" if gmod_language is "es"
-- "Banan"   if gmod_language is "sv-SE"
-- "Banane"  if gmod_language is "fr"
-- "Banana"  if gmod_language is anything else (missing phrases default to "en")

print( localify.Localize( "Fruit_Apple" ) )
-- "Apple"   if gmod_language is "en"
-- "Plátano" if gmod_language is "es"
-- "Äpple"   if gmod_language is "sv-SE"
-- "Pomme"   if gmod_language is "fr"
-- "Apple"   if gmod_language is anything else (missing phrases default to "en")


print( localify.Localize( "Fruit_Banana", "de" ) )
-- Prints "Banana" because no binding was found for "de" (German), which results in a lookup to
-- the default language "en" (English)



--[[--------------------------------------------------------------------------
--	Changing the fallback language
--------------------------------------------------------------------------]]--

localify.SetFallbackLanguage( "fr" )
-- Change the fallback language to French

print( localify.Localize( "Fruit_Banana", "de" ) )
-- Prints "Banane" because no binding was found for "de" (German), which results in a lookup to
-- the new default language "fr" (French)


localify.SetFallbackLanguage( "pt-BR" )
-- Change the fallback language to Brazilian Portuguese

print( localify.Localize( "Fruit_Banana", "de" ) )
-- Returns nil because no binding was found for "de" or the new default "pt-BR" (Brazilian Portuguese)



--[[--------------------------------------------------------------------------
--	Loading localization files
--------------------------------------------------------------------------]]--

localify.SetFallbackLanguage( "en" )
-- Change the fallback language back to English

localify.LoadSharedFile( "example_phrases.lua" )
-- Load a file with several example localized phrases onto both client and server

local L = localify.Localize
-- If you prefer the Nutscript style of localization

print( L"@Health" )
print( L("@Health", "es" ) )

print( L"!Volume!" )
print( L("!Volume!", "de" ) )

print( L"#Shield" )
print( L("#Shield", "he" ) )



--[[--------------------------------------------------------------------------
--	Adding and removing languages
--------------------------------------------------------------------------]]--

localify.AddLanguage( "zom", "Zombie" )
localify.Bind( "zom", "Attack1", "Braaaaains" )
localify.Bind( "zom", "Attack2", "Uuuuuuuungh" )
localify.Bind( "zom", "Attack3", "OOOAAARRRGGGHHH" )

localify.SetFallbackLanguage( "zom" )
-- Change the fallback language to Zombie

print( L"Attack1" )
-- Prints "Braaaaains"

print( L"Attack2" )
-- Prints "Uuuuuuuungh"

print( L"Attack3" )
-- Prints "OOOAAARRRGGGHHH"

localify.RemoveLanguage( "zom" )
-- Remove the Zombie language
-- "en" (English) automatically becomes the new fallback language

print( L"Attack1" )
-- Returns nil because the Zombie language no longer exists and no "en" binding was found