/** 
 	@page appendix_styleguide C. C++ Coding Style Guide

	@author Jamoma, Timothy Place

	@section appendix_styleguide_variables Variables

	<ul>
		<li>Declare all variables on separate lines.
		<li>If a variable is assigned immediately, then give it a default value in the declaration.
		<li>Prefer explicit types, e.g. TTObjectPtr rather than TTObject*.
		<li>User tabular formatting, as mentioned in the section "Whitespace"
	</ul>

	@section appendix_styleguide_functions Functions

	Functions always appear:

	<ol>
		<li>With the return type on the same line as the function name
		<li>With the arguments on the same line as the function name, unless they dont fit. In this case they follow in tabular format below the first argument name.
		<li>The open curly brace is on the line below the function name -- not the same line.
		<li>The closing curly brace is always on its own line
	</ol>

	@code{.cpp}
	TTHashPtr	TTNodeDirectory::getDirectory()
	{
		return this->directory;
	}
	@endcode

	<ul>
		<li>Whitespace between two functions should generally be two blank lines.
		<li>There should never be two consecutive blank lines within a function.
	</ul>

 	@section appendix_styleguide_arguments Arguments

	Prefer passing arguments as TTValueRef or const TTValueRef.

 	@section appendix_styleguide_whitespace Whitespace

	Multiple lines of similar function calls, similar definitions, should prefer tabular style formatting (which is to say, things are lined up in columns). This makes it faster to see the variant information between the lines, and also to edit multiple lines simultaneously using an editor such as TextMate.


 	@section appendix_styleguide_namingconventions Naming Conventions

	Macros should be all upper case, words divided by underscores

	Variables
	<ol>
		<li>CamelCase.
		<li>Variable names begin with lower-case letters
		<li>Class Member variables begin with 'm'
		<li>Constants begin with a 'k'
		<li>Globals begin with 'g'
		<li>Statics begin with 's'
		<li>member method names begin with lower-case letters
		<li>Classes or Global scope functions beggin with upper-case letters.
		<li>Library functions begin with 'TT', non-library functions do not.
	</ol>

 	@section appendix_styleguide_casting Casting

	<ol>
		<li>Be wary of casting if the problem/warning can be avoided in another way.
		<li>Readability is the most important thing.  So we dont always use the crazy C++ casting stuff...
		<li>Prefer C++ Style <tt>int(someValue)</tt> casts to <tt>(int)someValue</tt> casts.
	</ol>


 	@section appendix_styleguide_constructors Constructors

	<ol>
		<li>for TTObject subclasses, use the appropriate macro (such as TT_OBJECT_CONSTRUCTOR) to implement the function signature correctly
		<li>prefer initializers to assigning values
		<li>initializers should be indented one tab
	</ol>

*/