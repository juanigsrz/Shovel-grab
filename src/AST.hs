module AST where

import Text.Email.Parser (EmailAddress)

-- Resume's "owner" information
data PersonalInfo = Name     String
                  | Location String
                  | Address  String
                  | Homepage String
                  | Email    EmailAddress
    deriving (Show)

-- The resume has its output name, personal information and a list of groups
data Resume = Resume String [PersonalInfo] [Group]
    deriving (Show)

-- The basic element inside an entry
data EntryElement = Title        String
                  | Company      String
                  | Website      String
                  | Technologies String
                  | Description  String
                  | StartDate    String
                  | EndDate      String
                  | Bulletin     String
    deriving (Show)

-- An entry simply has all its items inside of it
data Entry = Entry [EntryElement]
    deriving (Show)

-- Group has its name and a list of entries
data Group = Group String [Entry]
           | Experience   [Entry]
           | Education    [Entry]
           | Projects     [Entry]
           | Skills       [Entry]
    deriving (Show)



