This is a detailed guide on how to write scripts, and some of the different things that you can do with them. For a more in-depth discussion of each particular method and function, please see the rest of the [[Ruby Scripting Manual]].

# Editing scripts

Scripts are just plain text files with a .rb file extension. Any text editor will work (such as Notepad or Textedit), however, there are some very nice text editors that can help identify errors and make Ruby scripts much easier to read by providing  syntax highlighting. We recommend installing and using one of the following programs for editing Ruby scripts (it'll be much easier on your eyes and brain):

* Windows
    * [Notepad++](http://notepad-plus-plus.org/) (free and open-source)
    * [Notepad2](http://www.flos-freeware.ch/notepad2.html) (free and open-source)
* Mac OSX
    * [TextMate 2](https://api.textmate.org/downloads/beta) (free and open-source)
    * [gedit](http://projects.gnome.org/gedit/) (free and open-source)
    * [TextWrangler](http://www.barebones.com/products/TextWrangler/) (free)
* Linux
    * [gedit](http://projects.gnome.org/gedit/) (free and open-source)
    * [kate](http://kate-editor.org/) (free and open-source)

>> **Scripting Tip**: Syntax highlighting generally depends on the file extension so the software knows what kind of file it is. If the Ruby Script file does not have the .rb extension, you might not get proper syntax highlighting! Make sure the file ends in .rb!

# Things you should know before starting
* Each cell has three required fields: onset, offset, and ordinal. Each cell also has at least one argument.
* In Ruby, onset, offset, and ordinal are all integers, not strings, and onset and offset are given in **milliseconds** from the beginning of the video (or other data stream), starting at 0.
* A cell's arguments are all represented as strings, so if you want to do math with a coded argument, you need to convert it to a number first. You do not need to do this with onset, offset, or ordinal. Those are already numbers. You can do this like so:
```ruby
# Set up a variable with a number as a string
a = "5"
# Convert it to an integer and save it to a new variable
b = a.to_i
# Print some math result
puts b + b
```
* To print something to the console, you have two options: the `p` command and the `puts` command. When in doubt, use `p`, as it will properly format arrays and lists in readable format, instead of mushing them all together like `puts` does. Use them like this:
```ruby
# Print 5
p 5
* Argument names rules:

# Also prints 5
puts 5

# Now to show the difference, print a list
p [5,6,7,8,9]
puts [5,6,7,8,9]
```

# Basic Script Format
**All scripts must include one line at the top in order to work**:
```ruby
require 'Datavyu_API.rb'
```
What this line does is load all of the helper functions that help Ruby talk to the Datavyu database. This line is necessary for all scripts that are run inside of Datavyu.

The rest of the code generally goes between `begin` and `end` tags like so:
```ruby
require 'Datavyu_API.rb'
begin
    # Get the variables that we want to work with

    # Do something to those variables

    # Write our changes to those variables back to the database
end
```

>> **Scripting Tip**: Anything that comes after a `#` character on a line in Ruby is a "comment", which means it won't be run. Use this to explain what you are doing in the code so you remember when you look at the script 6 months from now. This will be used heavily in the examples.

# Script Examples
* [Example-Template.opf](Example-Template.opf)

Lets walk through building a script. For the sake of this example, we'll be using the simple template in the link above. It contains an ID variable with some basic information such as subject number, testdate, birthdate, and condition. Then there is a trial variable that has two arguments: trialnum and outcome. Trial has no cells in it yet. We're going to be modifying this file, so download it and load it up into Datavyu!

## Loading Datavyu Variables into Ruby
Most scripts begin by first loading the variables we want to work with into Ruby. To do this, we use the function [[getVariable]], which takes a parameter that is simply the name of the variable in Datavyu. It returns the Ruby representation of the variable, which is what we work with. Eventually, we will save any changes to that variable back to the database.

>> **Scripting Tip**: In order to work with a variable in Ruby, it must first be loaded with [[getVariable]]. In order for any changes to that variable to be saved back to Datavyu, you have to send it back from Ruby to Datavyu with [[setVariable]]. Otherwise, any changes done to the variable are not saved (which can be a useful feature).

Example of how to load a variable into Ruby:
```ruby
require 'Datavyu_API.rb'
begin
    # Load the Datavyu variable "trial" into Ruby variable called trial.
    # The left hand side of this equation is the name of the Ruby variable.
    trial = getVariable("trial")
end
```

## Adding arguments to a variable
Now we probably want to do something with that variable that we just loaded.
Lets start by doing something simple, like adding arguments to a variable.
We use a method called "add_arg" to do this.
As hopefully you remember from your Ruby tutorial, methods are functions that are part of classes.
In this case, [[add_arg]] is a method of the [[RVariable]] class.
The basic idea is that a method "belongs" to an instance of a class, so using the above example, the RVariable trial "owns" a function called [[add_arg]] that will add an argument to its cells.

This somewhat confusing thing is probably most easily seen in an example:
```ruby
require 'Datavyu_API.rb'
begin
    # Load the Datavyu variable "trial" into Ruby variable called trial.
    trial = getVariable("trial")

    # Now that trial is loaded, lets add an argument called "unit" to it, which would be used
    # in the experiment to record which unit some equipment was at (or anything, this is Datavyu after all)
    # Notice how this method is called differently than the getVariable function.
    trial.add_arg("unit")

    # Now we have to write back our changes
    setVariable(trial)
end
```

## Adding cells to a variable
Lets do something a little more interesting than just adding an argument.
Lets add some cells to a column.
Say that we know that a new trial starts every minute from 0 to 4 minutes, yielding 5 trials. We want to make a new blank cell for each of these trials with the onset set to that time, so it is easy for the coder to code them.
```ruby
require 'Datavyu_API.rb'
begin
    # Load the Datavyu variable "trial" into Ruby variable called trial.
    trial = getVariable("trial")

    # We need to loop 5 times from 0 to 4
    for i in 0..4
        # Calculate the onset time that we want to set
        # Remember that all times in Datavyu are milliseconds
        time = i * 1000 * 60

        # Create the new cell.
        cell = trial.make_new_cell()

        # Now change the onset of the cell we just created
        cell.change_arg("onset", time)
    end

    # Now that the loop is finished (we're outside of the end), write
    # it back to the database
    setVariable(trial)
end
```

## Adding a new variable
Adding a new variable is also pretty easy, and is done with the [[createVariable]] function.
The first parameter of createVariable is the name of the new column, and all subsequent parameters are arguments to add to the variable. For example, if we wanted to make a variable called step with three arguments called foot (for the left or right foot), ht (for heel or toe), and direction (forward or backward step), we would do the following:
```ruby
require 'Datavyu_API.rb'
begin
    # Create the new variable with three arguments
    step = createVariable("step", "foot", "ht", "direction")

    # Now write it back to the database as a variable without any cells
    setVariable(step)
end
```

## Checking for typos
Another common use for scripts is to do a quick check for any typos that a coder made.
This is mostly just in case a coder typed in an invalid code (entered an "h" when only "j" and "k" are considered valid codes) or maybe hit more than one key ("hj" instead of "j" or "k").
These kinds of scripts are best run immediately after each coding pass so that errors can be caught early and recoded.
The function used for this is [[checkValidCodes]], which has a somewhat strange parameter setup.

The first parameter of the function is the name of the variable that you want to check, for example, if we wanted to check a variable named "trial", we'd enter "trial" as the first parameter. The rest of the parameters are, in programming lingo, called key/value pairs. The key is the name of an argument in that column, and the value is an array of valid codes for that argument. The function checks each argument against its list of valid codes. This is probably best shown by example, assuming we have the variable above called "step" and we want to check its codes:
```ruby
require 'Datavyu_API.rb'
begin
    # Check for typos. Notice the square brackets. These denote arrays. So the basic format is:
    # ... argumentname, [validarg1, validarg2, validarg3], ...
    checkValidCodes("step", "foot", ["l", "r"], "ht", ["h", "t"], "direction", ["f","b"])
end
```
We can also do this exact same thing in a bit clearer of a way by assigning the valid codes to Ruby variables first:
```ruby
require 'Datavyu_API.rb'
begin
    # Store each of the valid code arrays into a variable first so it is easier to read
    footCodes = ["l", "r"]
    htCodes = ["h", "t"]
    directionCodes = ["f", "b"]

    # Check for typos. Notice the square brackets. These denote arrays. So the basic format is:
    # ... argumentname, [validarg1, validarg2, validarg3], ...
    checkValidCodes("step", "foot", footCodes, "ht", htCodes, "direction", directionCodes)
end
```

## Making a reliability variable
Creating a reliability column is another very common task. The idea is that we want to take some subset of cells from an already coded column and create blank or semi-blank cells in a new column for a reliability coder to code, to make sure that two people can see the same things in the data. To do this, we use the function [[makeReliability]].

The first parameter is the variable that we want to create a reliability column **from**, our primary variable. The second is what what we want to call our reliability variable. The third parameter how many cells we want to skip. For example, a value of 2 means "every other cell", a value of 3 is "every third cell", and so on. 1 means copy all of the cells, and 0 means make a blank column.

The rest are the arguments that we want to copy over from the primary variable that we don't want the reliability coder to have to code. This could be things such as the trial number or other non-essential information. It is also very helpful to copy over the onset time of a trial so the reliability coder can just to that point in the video. Given our trial variable above, we want to make a new variable called "rel.trial" with blank offset and outcome arguments, but onset and trialnum should be carried over (we don't care about the reliability coder coding those). We do that like this:
```ruby
require 'Datavyu_API.rb'
begin
    # Make a new reliability variable that makes a new semi-blank cell for every other primary
    # cell. Copy over the onset and the trialnum though
    makeReliability("trial", "rel.trial", 2, "onset", "trialnum")
end
```
Note that we do **not** have to write the variable back to the database. The [[makeReliability]] function will take care of that for us automatically. This is the only function that this is true for.

## Checking reliability
Once the reliability variable is coded, we want to compare the cells in the reliability column to those in the primary column. An easy way to do this is to use the [[checkReliability]] function. This function simplifies the process by taking the primary and reliability variables and comparing the cells, giving you some quick at-a-glance statistics about the reliability (such as percent agreement). The function takes four parameters. The first is the primary variable, the second is the reliability variable, the third is the binding argument (more on this in a second), and the fourth is an optional file to write the output to.

The third argument is the tricky one. In order for the function to know which cells to compare, it needs to have some parameter that is unique to each combination of primary and reliability cells. An example of this would be a trial number that is coded into each cell: that way even if we only did every 3rd cell in the reliability column (or some randomized subset), then we know that the primary cell with a certain trial number matches the reliability cell with that same trial number, and we can compare the codes between those two.  It is best to have had this variable carried over when making the reliability column with [[makeReliability]]. Any unique argument will work though, including onsets.

The fourth argument is an optional file to print to. Pass the string representing the location of the file you'd like to write to. See how to do this in the example below:
```ruby
require 'Datavyu_API.rb'
begin
    # We have two variables that we want to compare, trial and rel.trial. They match on an argument called trialnumber.
    # We want to dump the results to a file on the desktop.

    # As before, File.expand_path with unfold the ~ in the filename to be our users' home directory
    dump_file = File.expand_path("~/Desktop/relcheck.txt")
    checkReliability("trial", "rel.trial", "trialnum", dump_file)
end
```

## Exporting your data

### Automatic exporting methods
Coming soon!

### Manual exporting methods

There are many ways to export your data.
We will cover four common approaches here:

1. a straight dump to CSV file where cells correspond to what was coded in Datavyu
1. a straight frame-by-frame dump of what was happening on each frame
1. a fancier way of exporting the data that loops through each column and nests cells appropriately
1. a still fancier way of achieving nesting mentioned in the previous method but if your cells do not necessarily nest.

These methods will be covered in the order they are listed above, which also happens to be in order of increasing complexity.

### Method 1: Dumping to a CSV with no modifications at all
This method is actually much easier to do (only 1 line!) with the new R scripting functions.
Please see the R guide for instructions.
However, we will still cover how to do this in Ruby here.

### Method 2: Frame by frame dump
We can also dump a file frame by frame if we know the framerate of the video that was coded.
The idea here is to generate a new row in a spreadsheet for each frame of the video, with the value of each argument in each cell in its own column.
For long videos, this type of exporting may take too long (a 2 hour video at 30fps is 216,000 rows!), but for short videos this is definitely a very easy way to export files.

To do this, we loop over all of the columns in the spreadsheet and grab the current cell at each time, moving one frame at a time (so there will be an entry for 00:00:033, 00:00:066, and so on, all the way until the end of a video for a 30fps video).



### Method 3: Nested dump

### Method 4: Nested dump with un-nested cells


## Running a script across multiple files
use require
