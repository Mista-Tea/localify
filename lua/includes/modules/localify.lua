--[[--------------------------------------------------------------------------
	Localify Module
	
	Author:
		Mista-Tea ([IJWTB] Thomas)
	
	License:
		The MIT License (MIT)

		Copyright (c) 2015 Mista-Tea

		Permission is hereby granted, free of charge, to any person obtaining a copy
		of this software and associated documentation files (the "Software"), to deal
		in the Software without restriction, including without limitation the rights
		to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
		copies of the Software, and to permit persons to whom the Software is
		furnished to do so, subject to the following conditions:

		The above copyright notice and this permission notice shall be included in all
		copies or substantial portions of the Software.

		THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
		IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
		FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
		AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
		LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
		OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
		SOFTWARE.
			
	Changelog:
----------------------------------------------------------------------------]]

--[[--------------------------------------------------------------------------
-- 	Namespace Tables
--------------------------------------------------------------------------]]--

module( "localify", package.seeall )

languages = {
	bg        = "Bulgarian",
	cs        = "Czech",
	da        = "Danish",
	de        = "German",
	el        = "Greek",
	["en-pt"] = "English (Pirate)",
	en        = "English (UK)",
	es        = "Spanish",
	et        = "Estonian",
	fi        = "Finnish",
	fr        = "French",
	he        = "Hebrew",
	hr        = "Croatian",
	hu        = "Hungarian",
	it        = "Italian",
	ja        = "Japanese",
	ko        = "Korean",
	lt        = "Lithuanian",
	nl        = "Dutch",
	no        = "Norwegian",
	pl        = "Polish",
	["pt-br"] = "Portuguese (Brazil)",
	["pt-pt"] = "Portuguese (Portugal)",
	ru        = "Russian",
	sk        = "Slovak",
	["sv-se"] = "Swedish (Sweden)",
	th        = "Thai",
	tr        = "Turkish",
	uk        = "Ukranian",
	vi        = "Vietnamese",
	["zh-cn"] = "Chinese (China, Simplified)",
	["zh-tw"] = "Chinese (Taiwan, Traditional)",
}

tokens = tokens or {
	bg        = {},
	cs        = {},
	da        = {},
	de        = {},
	el        = {},
	["en-pt"] = {},
	en        = {},
	es        = {},
	et        = {},
	fi        = {},
	fr        = {},
	he        = {},
	hr        = {},
	hu        = {},
	it        = {},
	ja        = {},
	ko        = {},
	lt        = {},
	nl        = {},
	no        = {},
	pl        = {},
	["pt-br"] = {},
	["pt-pt"] = {},
	ru        = {},
	sk        = {},
	["sv-se"] = {},
	th        = {},
	tr        = {},
	uk        = {},
	vi        = {},
	["zh-cn"] = {},
	["zh-tw"] = {},
}

--[[--------------------------------------------------------------------------
-- 	Localized Functions & Variables
--------------------------------------------------------------------------]]--

local error = error
local include = include
local tostring = tostring
local GetConVar = GetConVar
local AddCSLuaFile = AddCSLuaFile

DEFAULT = DEFAULT or "en"
CVarLocale = GetConVar( "gmod_language" )

--[[--------------------------------------------------------------------------
--	Namespace Functions
--------------------------------------------------------------------------]]--

--[[--------------------------------------------------------------------------
-- 	localify.LoadSharedFile( string )
--
--	Loads a file containing localization phrases onto the server and connecting clients.
--]]--
function LoadSharedFile( path )
	include( path )
	if ( SERVER ) then AddCSLuaFile( path ) end
end

--[[--------------------------------------------------------------------------
-- 	localify.LoadServerFile( string )
--
--	Loads a file containing localization phrases onto the server.
--]]--
function LoadServerFile( path )
	if ( CLIENT ) then return end
	include( path )
end

--[[--------------------------------------------------------------------------
-- 	localify.LoadClientFile( string )
--
--	Loads a file containing localization phrases onto connecting clients.
--]]--
function LoadClientFile( path )
	if ( SERVER ) then AddCSLuaFile( path ) return end
	include( path )
end

--[[--------------------------------------------------------------------------
-- 	localify.IsValidLanguage()
--
--	Checks if the passed 2- or 4-letter language code is supported by Localify.
--	Returns true if valid, false if invalid/
--]]--
function IsValidLanguage( lang )
	return lang and languages[ lang:lower() ]
end

--[[--------------------------------------------------------------------------
-- 	localify.GetLocale()
--
--	Retrieves the client or server's in-game locale (separate from system locale).
--	The cvar holding this value is "gmod_language".
--]]--
function GetLocale()
	return CVarLocale:GetString() == "" and DEFAULT or CVarLocale:GetString():lower()
end

--[[--------------------------------------------------------------------------
-- 	localify.SetDefault()
--
--	Sets the fallback language to use when a localized phrase is unavailable.
--	This is set to "en" (English) by default.
--]]--
function SetDefault( lang )
	if ( not IsValidLanguage( lang ) ) then error( "Invalid language provided ('"..tostring(lang).."')" ) return end
	
	DEFAULT = lang:lower()
end

--[[--------------------------------------------------------------------------
-- 	localify.Bind( string, string )
--
--	Binds the token (key) and localized phrase (value) to the given language (lang).
--
--	Example: localify.Bind( "en", "#Hello", "Hello" )
--	Example: localify.Bind( "es", "#Hello", "Hola" )
--	Example: localify.Bind( "fr", "#Hello", "Bonjour" )
--]]--
function Bind( lang, key, value )
	if ( not IsValidLanguage( lang ) ) then error( "Invalid language provided ('"..tostring(lang).."')" ) return end
	
	tokens[ lang:lower() ][ key ] = value
end

--[[--------------------------------------------------------------------------
-- 	localify.Localize( string, string )
--
--	Retrieves the localized phrase associated with the token (key).
--	If a language (lang) is provided, the phrase bound to that language will be returned.
--	If no language is provided, the language will default to the client or server's locale.
--	If a localized phrase is not found, the phrase associated with the default language
--	('en' unless manually changed) will be returned, if any.
--	Will return nil if no binding exists.
--
--	Example: local str = localify.Localize( "#Hello" )
--	Example: local str = localify.Localize( "#Hello", "es" )
--	Example: local str = localify.Localize( "#Hello", "fr" )
--]]--
function Localize( key, lang )
	if ( lang and not IsValidLanguage( lang ) ) then error( "Invalid language provided ('"..tostring(lang).."')" ) return end
	
	return tokens[ (lang and lang:lower()) or GetLocale() ][ key ] or tokens[ DEFAULT ][ key ]
end