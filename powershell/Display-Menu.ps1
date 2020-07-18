<#
    Display Menu allows you to easily make menus inside your console-driven Powershell scripts
    It dynamically displays a menu and returns a value that matches a uniform set of values
    You can then run a set of switch logic based on these values to take action based on them.
#>
function Display-Menu($menuItems){
    Write-Host $menuItems.header -ForegroundColor Green
    foreach($option in $menuItems.options){
        Write-Host $option.name
    }
    $selection = Read-Host -Prompt $menuItems.prompt
    Write-Host "`n"
    $selection = Validate-Selection $selection $menuItems
    return $selection
}
<#
    Validate selection is the thing that ensures that the values returned by the menu
    are uniform and can be matched by switch statements in your menu logic
    Entirely invalid selections should still be handled by the main menu logic e.g. Make-Example-Selection

#>
function Validate-Selection($selectionToValidate, $menuItems){
    foreach($option in $menuItems.options){
        if ($option.selectors.Contains($selectionToValidate)){
            return $option.contents
        }
    }
    return "Invalid Selection"
}

<# 
    This is an example of the menu at work. Display-Menu handles displaying menu items and allowing the user to make a selection
    While this function actually takes action on it.
    Here, the switch statement allows you to just run individual commands when this menu runs
    However you may want to make a function like this something that takes in an object to be modified 
    and then spits out that modified object at the end—I've noted this with comments. 
    In that case, each switch option would change elements of the object passed in, then return the modified object

#>
function Make-Example-Selection(){ # Optional - Pass in an object that you want to modify
    do {
        do{
            Write-Host "================== Generic Selection Menu ====================" -ForegroundColor Green
            $selectionMade = Display-Menu($menuItems)
        }until($selectionMade)
        switch($selectionMade){
            "UniqueStringToIdentifyOption1"{
                $anotherSelectionMade = Display-Menu($secondLayerMenuItems) # You can even nest a menu inside another menu!
                if ($anotherSelectionMade -eq "Manual Entry"){ 
                    $anotherSelectionMade = Read-Host -Prompt "Manual Entry for this menu option" # An example of making a selection manually 
                }
                Write-Host "You've made the following selection $anotherSelectionMade"
            }
            "UniqueStringToIdentifyOption2"{
                Write-Host "You've taken action on Option 2"

            }
            "UniqueStringToIdentifyOption3"{
                Write-Host "You've taken action on option 3"
            }
            "Invalid Selection"{
                Write-Host "You've made an invalid selection, please pick again"
            }
        }
    }until($selectionMade -eq "Exit")
    # optional - return object provided as argument that has been changed by the function
}


<# 
    Menu Data example
    The Header explains what type of options are included in the list
    The Prompt is what's provided to Read-Host when you're actually making the selection
    The options:
        Name = the text displayed on screen
        Selectors = what the end user can select to pick this option
        Contents = The value that will be returned by the menu and can be used for switch statements in specific menu display code

#>
$menuItems = @{
    'header' = "You are selecting from THIS list of options"
    'prompt' = "Enter the letter or number of the change you'd like to make"
    'options' = @(
        @{
            'name' = '1. This is Option 1'
            'selectors' = @('1', '1.','a','A','Option 1')
            'contents' = 'UniqueStringToIdentifyOption1'
        }
        @{
            'name' = '2. This is Option 2'
            'selectors' = @('2', '2.','b','B','Option 2')
            'contents' = 'UniqueStringToIdentifyOption2'
        }
        @{
            'name' = '3. This is Option 3'
            'selectors' = @('3', '3.','c','C','Option 3')
            'contents' = 'UniqueStringToIdentifyOption3'
        }
        @{
            'name' = '4. Exit - All Selections Made'
            'selectors' = @('4', '4.','d','D','Option 4')
            'contents' = 'Exit'
        }
    )

}

# Menu Data for the second layer menu
$secondLayerMenuItems = @{
    'header' = 'You can select from this sub-list of options for option 1 in the main list'
    'prompt' = 'Please enter the number of the selection you want to make'
    'options' = @(
        @{
            'name' = '1. Default Selection'
            'selectors' = @('1', '1.','a','A','Default Selection')
            'contents' = 'UniqueStringToIdentifyOption1'
        }
        @{
            'name' = '2. Manual Entry'
            'selectors' = @('2', '2.','b','B','Manual Entry')
            'contents' = 'Manual Entry'
        }
    )
}

# Actually display a menu, here.
Make-Example-Selection