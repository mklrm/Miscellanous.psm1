# Miscellaneous.psm1
For now I am planning to just use this for various functions that I'm testing the actualy usefulness... or to keep this as a hodge-podge collection of stuff I can't think of where else to arrange.
## New-ObjectPropertyName
The function takes three inputs
    InputObject, one or more any type of object
    NewName, one or more strings
    MemberType, one or more strings

The function looks for properties in Input Objects of Member Types and then presents you with a keyboard navigable list a of New Names for each property. You pick your names and the function outputs new objects with the new names you picked for your properties. It even asks after the first object whether you want to use the same picks for the rest of your Input Objects.

Obviously there's all sorts of improvements to make, it does not for example attempt to keep the the same object type as those of the ones you input. Interface wise it's kind of horrid. The menu needs a title above it or something.
