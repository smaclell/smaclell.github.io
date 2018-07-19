---
layout: post
title:  "Parameterized Tests Made Simple"
date:   2015-09-18 00:00:07
tags: testing code nunit
---

I often find my tests look very similar. The behaviour of the tests are
exactly the same with different input and output data. Data driven or parameterized tests in [NUnit][nunit]
are a great way to combine tests with different values and the same behaviour.
In this post I will show you how to use NUnit's features to create parameterized tests.

<div class="disclaimer">
<p>
If you like this post and want to go deeper, I would like to recommend
<a href="https://github.com/gowland/nunit-docs/blob/master/valuesource-tutorial.md">"NUnit ValueSource: the Complete Tutorial"</a> by Robert Gowland. There are alot more examples which show
how to use the various attributes together. This post is just a teaser. Go there
when you are done if you want the full story.
</p>
</div>

In order to demo parameterized test I will be using a simple ``StringCalculator`` based
on the [String Calculator kata][kata]. The class, ``StringCalculator`` has one
method ``Add`` which takes in a string containing delimited numbers as input
and returns the sum of the numbers.

Written normally each test would call ``Add`` with different input and then verify the total. Using parameterized test
cases we can easily add new cases which clearly show how the input and the total are related.

If I was to write these tests without using parameters I would need to repeat
nearly identical code for each test. The code for the tests would look like this:

{% highlight csharp %}
using NUnit.Framework;

[TestFixture]
public class SimpleStringCalculatorTests {

    [Test]
    public void Add_EmptyString_ReturnsZero() {
        StringCalculator calculator = new StringCalculator();

        int total = calculator.Add( "" );

        Assert.AreEqual( 0, total );
    }

    [Test]
    public void Add_SingleNumber_ReturnsTheNumber() {
        StringCalculator calculator = new StringCalculator();

        int total = calculator.Add( "1" );

        Assert.AreEqual( 1, total );
    }

    [Test]
    public void Add_TwoNumbers_ReturnsTheTotal() {
        StringCalculator calculator = new StringCalculator();

        int total = calculator.Add( "1,2" );

        Assert.AreEqual( 3, total );
    }
}
{% endhighlight %}

We can do better. Thankfully NUnit allows you to create
[parameterized tests][parameterized] using special attributes.
Using these attributes, we can dramatically reduce the duplicate code in the
tests.

In order to use these attributes you will need to do the following steps:

1. Promote the constant values you want to parametize into parameters on the test method
2. Apply the attributes to define the cases you want to test
3. ...
4. Profit

Refactoring the tests above my I am left with a single test method:

{% highlight csharp %}
using NUnit.Framework;

[TestFixture]
public class RefactoredStringCalculatorTests {

    // Warning: This will not run in its current state.
    //          We need to add the attributes first!
    [Test]
    public void Add_SimpleInputs_AddsNumbers( string numbers, int expectedTotal ) {
        StringCalculator calculator = new StringCalculator();

        int total = calculator.Add( numbers );

        Assert.AreEqual( expectedTotal, total );
    }
}
{% endhighlight %}

Now we are ready to explore what the different attributes do.

## Complete Cases

The first set of attributes, ``TestCase`` and ``TestCaseSource``, define complete test cases.
You can think of them like rows
in a table containing values for each of the test's parameters. The test framework will call the test
method one test case at a time with all the test case's parameter values.

Both attributes apply to the test method itself. ``TestCase`` directly contains
values for its test case(s) whereas ``TestCaseSource`` refers to another method/type which
will supply the values. I will explain the difference more below.

### TestCase Attribute

The [TestCase][TestCase] attribute is applied directly to a single test and
provide values for one test case. If you want multiple cases add more copies of
the attribute! The values provided to the TestCase attribute line up with their matching parameter. More
options can be configured using named parameters on the attribute, such as the
test name or expected exceptions.

The main drawback to this approach is only simple compile time constants can be
used as parameters. This simplicity is not all bad. It helps keep the tests
focused and avoids having more complicated logic sneak into your test setup.

{% highlight csharp %}
using NUnit.Framework;

[TestFixture]
public class TestCaseStringCalculatorTests {

    [TestCase( "", 0 )]
    [TestCase( "1", 1 )]
    [TestCase( "1,2", 3 )]
    public void Add_SimpleInputs_AddsNumbers( string numbers, int expectedTotal ) {
        StringCalculator calculator = new StringCalculator();

        int total = calculator.Add( numbers );

        Assert.AreEqual( expectedTotal, total );
    }
}
{% endhighlight %}

### TestCaseSource Attribute

The [TestCaseSource][TestCaseSource] attribute is applied to the test method
like the ``TestCase`` attribute. This method delegates creating parameter values
to other methods, fields or types. Using the ``TestCaseSource`` is more
flexible and can be used to provide more complicated parameter types. Within
the source method you can reuse objects/data for multiple tests. The same
source method can also be reused for multiple tests.

To use ``TestCaseSource`` you must provide a ``sourceName`` and/or ``sourceType``.
If only ``sourceName`` is used the field/method is assumed to be in the same
class as the test.

The type of data provided by the source is very flexible.  For simple parameters
normal arrays or ``object[]`` can be returned from the source.
I prefer using ``IEnumerable<TestCaseData>`` which has extra options like ``TestCase`` for configuring the test such as test name. Review the
[TestCaseSource][TestCaseSource] documentation for the additional rules for source types.

In this example we will use ``"AddCases"`` as our source
method which returns ``IEnumerable<TestCaseData>``:

{% highlight csharp %}
using System.Collections.Generic;
using NUnit.Framework;

[TestFixture]
public class TestCaseSourceStringCalculatorTests {

    private static IEnumerable<TestCaseData> AddCases() {
        yield return new TestCaseData( "", 0 );
        yield return new TestCaseData( "1", 1 );
        yield return new TestCaseData( "1,2", 3 );
    }

    [Test, TestCaseSource( "AddCases" )]
    public void Add_SimpleInputs_AddsNumbers( string numbers, int expectedTotal ) {
        StringCalculator calculator = new StringCalculator();

        int total = calculator.Add( numbers );

        Assert.AreEqual( expectedTotal, total );
    }
}
{% endhighlight %}

## Single Parameters

Another option is to apply attributes to the test parameters. They can behave
like ``TestCase`` and ``TestCaseSource`` for a single parameter. For tests with
multiple parameters the behaviour is more complicated and can be used to create
many test cases.

The following attributes are placed on a parameter and control a single parameter's values:

* [Values][Values]
* [ValueSource][ValueSource]
* [Random][Random]
* [Range][Range]

Whereas the following attributes are applied to the method and define how values
from multiple parameters are combined to create complete test cases:

* [Combinatorial][Combinatorial]
* [Sequential][Sequential]
* [Pairwise][Pairwise]

Clear as mud? That is okay! I have a few examples to clarify how to use these
attributes.

### Values Attribute

This simple example shows using the ``Values`` attribute inline with a single
parameter. The values from the attribute each create a single test case to be
executed. This behaves like ``TestCase`` for a single parameter.

{% highlight csharp %}
using NUnit.Framework;

[TestFixture]
public class ValuesStringCalculatorTests {

    [Test]
    public void Add_NullOrBlank_ReturnsZero(
        [Values( null, "", " ", "\t", "\n" )] string input
    ) {
        StringCalculator calculator = new StringCalculator();

        int total = calculator.Add( input );

        Assert.AreEqual( 0, total );
    }
}
{% endhighlight %}

### ValueSource Attribute

The ``ValueSource`` provides values from a method, or field or type. Just how
``Values`` behaves like ``TestCase``, ``ValueSource`` behaves like
``TestCaseSource``. In this example I am using the ``NullOrBlankCases`` array
to determine the values for each test case.

{% highlight csharp %}
using NUnit.Framework;

[TestFixture]
public class ValueSourceStringCalculatorTests {

    private static string[] NullOrBlankCases = new string[] {
        null,
        "",
        " ",
        "\t",
        "\n"
    };

    [Test]
    public void Add_NullOrBlank_ReturnsZero(
        [ValueSource( "NullOrBlankCases" )] string input
    ) {
        StringCalculator calculator = new StringCalculator();

        int total = calculator.Add( input );

        Assert.AreEqual( 0, total );
    }
}
{% endhighlight %}

### Range and Random Attributes

``Range`` and ``Random`` are two special cases for specifying numbers.

``Range`` generates test cases between a starting point, an end point and
optionally the step size between each test case. In the example below, I use
``Range`` starting at 2 and going to 10 in steps of 2 to produce the cases
2, 4, 6, 8, 10.

{% highlight csharp %}
using NUnit.Framework;

[TestFixture]
public class RangeStringCalculatorTests {

    [Test]
    public void Add_EvenNumbersBetweenTwoAndTen_ReturnsTheNumber(
        [Range( 2, 10, 2 )] int number
    ) {
        StringCalculator calculator = new StringCalculator();

        string numbers = number.ToString();
        int total = calculator.Add( numbers );

        Assert.AreEqual( number, total );
    }
}
{% endhighlight %}

``Random`` uses random numbers to create multiple test cases. The values can
optionally be constrained between two values. Be careful. The random numbers
might be very large or very small which can cause your tests to randomly fail.
The example below creates 5 tests cases for random numbers between 0 and 10.

{% highlight csharp %}
using NUnit.Framework;

[TestFixture]
public class RandomStringCalculatorTests {

    [Test]
    public void Add_RandomNumberBetweenZeroAndTen_ReturnsTheNumber(
        [Random( 0, 10, 5 )] int number
    ) {
        StringCalculator calculator = new StringCalculator();

        string numbers = number.ToString();
        int total = calculator.Add( numbers );

        Assert.AreEqual( number, total );
    }
}
{% endhighlight %}

### Combining Multiple Parameters

Cool! Dealing with a single parameter is really easy. How does it work with
multiple parameters? This is where the other attributes are used to control the
behaviour for combining the values from all the parameters. They are placed on the
method and are mutually exclusive.

The default behaviour is to evaluate all combinations of the parameters.
You can specify this behaviour explicitly using the ``Combinatorial`` attribute
on the method. Be careful, this can generate many tests if you have lots of values
or parameters.

You can combine values from the parameters in the order they are declared using the ``Sequential`` attribute.
This is like treating the values for each parameter as a column in a table.
Each row is then forms a single test case. I try to use this option sparingly.
Often the parameter values do not line up visually and it can be hard to
determine what the cases will be. The example below will have the following
cases executed by the attribute:

* "", 0
* "1", 1
* "1,2", 3

{% highlight csharp %}
using NUnit.Framework;

[TestFixture]
public class ParameterStringCalculatorTests {

    private static string[] TestNumbers() {
        return new string[] { "", "1", "1,2" };
    }

    private static int[] TestTotals() {
        return new int[] { 0, 1, 3 };
    }

    [Test, Sequential]
    public void Add_SimpleInputs_AddsNumbers(
        [ValueSource( "TestNumbers" )] string numbers,
        [ValueSource( "TestTotals" )] int expectedTotal
    ) {
        StringCalculator calculator = new StringCalculator();

        int total = calculator.Add( numbers );

        Assert.AreEqual( expectedTotal, total );
    }
}
{% endhighlight %}

The last attribute which modifies how the parameters are combined is ``Pairwise``.
It uses a heuristic to create cases covering every possible pair of parameters.
The intend is to generate fewer cases than ``Combinatorial`` while still
providing good coverage. I have not used it on a project before. If you
have too many tests caused by using ``Combinatorial`` you may want to try using
this attribute.

## Go Test, With Cases!

I hope you enjoyed this overview of the how to create test cases with NUnit. To
make it easy to work through the examples I have uploaded a [repository][repo] to
github with sample code for each of the cases. I even included a few bonus
examples I made along the way. Enjoy.

Test cases are great fun and can help cut down on duplication in your tests.
If you think all your tests all look the same, try using test cases to clean them up.

[nunit]: http://www.nunit.org
[kata]: http://osherove.com/tdd-kata-1/
[parameterized]: http://www.nunit.org/index.php?p=parameterizedTests&r=2.5.10
[TestCase]: http://www.nunit.org/index.php?p=testCase&r=2.6.4
[TestCaseSource]: http://www.nunit.org/index.php?p=testCaseSource&r=2.6.4
[Values]: http://www.nunit.org/index.php?p=values&r=2.6.4
[ValueSource]: http://www.nunit.org/index.php?p=valueSource&r=2.6.4
[Random]: http://www.nunit.org/index.php?p=random&r=2.6.4
[Range]: http://www.nunit.org/index.php?p=range&r=2.6.4
[Combinatorial]: http://www.nunit.org/index.php?p=combinatorial&r=2.6.4
[Sequential]: http://www.nunit.org/index.php?p=sequential&r=2.6.4
[Pairwise]: http://www.nunit.org/index.php?p=pairwise&r=2.6.4
[repo]: https://github.com/smaclell/nunit-testcase-examples
