# NAME

Jo::Util - Loose collection of some tools

# SYNOPSIS

Import the desired functions and use them as described for each
individual one.

```perl
use Jo::Util 'func_name';
```

Imported names may be modified like:

```perl
    use Jo::Util func_name => {-as => 'other_name'}
```

See [Exporter::Tiny::Manual::Importing](https://metacpan.org/pod/Exporter::Tiny::Manual::Importing) for details.

# EXPORT

Functions that may be exported by this modure are:

- aref
- genlist
- splitdata
- stopmatch

# SUBROUTINES

## aref _LIST_

Returns a reference to an array consisting of the elements of _LIST_
or `undef` if _LIST_ is empty.

### Examples

```perl
    $pair = aref each %h;
    print "$pair->[0] => $pair->[1]\n" if $pair;
```

## genlist _BLOCK_

Calls given _BLOCK_ repeatedly in list context and collects all
returned items into a single list.
Stops when _BLOCK_ returns `undef` or an empty list and returns the
list of gathered items.

### Examples

Something similar to ["pairs" in List::Util](https://metacpan.org/pod/List::Util#pairs):

```
    @pairs = genlist {aref each %h};
```

Create a list from a `for(;;)`-like construct:

```perl
    use feature 'state';
    
    @forlist = genlist {state $x = 1; my $y = $x;
            $x *= 2; $y <= 2048 ? $y : undef};
```

## splitdata

Split the data from the `DATA` file handle into several parts,
separated by lines of the form

```
    __NAME_IN_UPPERCASE__
```

Returns a hash with the names as keys and corresponding file handles to
read the data from as values.

When called with the parameter "-create", `split_data` will create file
handles named like the parts in the caller's namespace.

The first data part is always named "DATA".

### Examples

```perl
use Jo::Util 'split_data';

my %data = splitdata -create;

while (<DATA>) {
    # process line from DATA
}

    # or

while (readline $data{EXT}) {
    # process line from EXT
}

__DATA__
data 1
data 2
__EXT__
ext 1
ext 2
```

There is not really a need for this function, as almost the same can be
accomplished using:

```
    open EXT, '<', \(<<'EOF');
    ext 1
    ext 2
    EOF
```

## stopmatch _REGEX_

Returns a regular expression that matches everything up to but not
including the given _REGEX_.
This is something similar to

```
    [^...]
```

where "not to be matched" isn't from a given set of characters, but by
the given regular expression.

### Examples

Match everything up to a word in capital letters
	$re = stopmatch qr{\\b\[A-Z\]+\\b};
	$found = /($re)/ for 'Some text up to THIS word';
	# $found is 'Some text up to '

# SEE ALSO

[Exporter::Tiny::Manual::Importing](https://metacpan.org/pod/Exporter::Tiny::Manual::Importing)

# AUTHOR

Jörg Sommrey, `<28217714+jo-37 at users.noreply.github.com>`

# LICENSE AND COPYRIGHT

Copyright 2020 Jörg Sommrey.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

[http://www.perlfoundation.org/artistic\_license\_2\_0](http://www.perlfoundation.org/artistic_license_2_0)

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
