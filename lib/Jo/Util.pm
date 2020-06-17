package Jo::Util;

use 5.008;
use strict;
use warnings FATAL => 'all';

use Exporter::Tiny;
use Carp;

=pod

=encoding utf8

=head1 NAME

Jo::Util - Loose collection of some tools

=head1 VERSION

This document describes Jo::Util version 0.03

=cut

our
$VERSION = '0.03';

=head1 SYNOPSIS

Import the desired functions and use them as described for each
individual one.

	use Jo::Util 'func_name';

Imported names may be modified like:

	use Jo::Util func_name => {-as => 'other_name'}

See L<Exporter::Tiny::Manual::Importing> for details.

=head1 EXPORT

Functions that may be exported by this modure are:

=over

=item * aref

=item * genlist

=item * splitdata

=item * stopmatch

=item * narray

=back

=cut

our @EXPORT_OK = qw(aref genlist splitdata stopmatch narray);
our @ISA = qw(Exporter::Tiny);

=head1 SUBROUTINES

=head2 aref I<LIST>

Returns a reference to an array consisting of the elements of I<LIST>
or C<undef> if I<LIST> is empty.

=head3 Examples

	$pair = aref each %h;
	print "$pair->[0] => $pair->[1]\n" if $pair;

=cut

sub aref {
	@_ ? [@_] : undef;
}

=head2 genlist I<BLOCK>

Calls given I<BLOCK> repeatedly in list context and collects all
returned items into a single list.
Stops when I<BLOCK> returns C<undef> or an empty list and returns the
list of gathered items.

=head3 Examples

Something similar to L<List::Util/pairs>:

	@pairs = genlist {aref each %h};

Create a list from a C<for(;;)>-like construct:

	use feature 'state';
	
	@forlist = genlist {state $x = 1; my $y = $x;
		$x *= 2; $y <= 2048 ? $y : undef};

=cut

sub genlist (&) {
    my $gen = shift;
    my @res;
    while (my @g = &$gen()) {
        last if @g == 1 && !defined $g[0];
        push @res, @g;
    }
    return @res;
}

=head2 splitdata

Split the data from the C<DATA> file handle into several parts,
separated by lines of the form

	__NAME_IN_UPPERCASE__

Returns a hash with the names as keys and corresponding file handles to
read the data from as values.

When called with the parameter "-create", C<split_data> will create file
handles named like the parts in the caller's namespace.

The first data part is always named "DATA".


=head3 Examples

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

There is not really a need for this function, as almost the same can be
accomplished using:

	open EXT, '<', \(<<'EOF');
	ext 1
	ext 2
	EOF

=cut

sub splitdata {
    no strict 'refs';

    my $create = ($_[0] // '') =~ /^-create$/;
    my $caller = caller;
    my $data = *{$caller . '::DATA'};
    my $p = qr{[A-Z]+(?:[A-Z0-9_]*[A-Z0-9])?};
    my (%fh, %data);

    if (eof($data)) {
        carp "cannot read from *${caller}::DATA";
        return;
    }

    for (do {local $/; <$data>}) {
        (%data) = (
            'DATA',
            m{((?:(?!^__${p}__$).)*)}ms,
            m{(?:^__($p)__\n)(.*?)(?=(?:^__${p}__$|\z))}msg,
        );
    }
    close $data;

    while (my ($part, $content) = each %data) {
        open my $fh, '<', \$content or croak 'cannot open in-memory file';
        $fh{$part} = $fh;
        *{$caller . '::' . $part} = $fh if $create;
    }
    return %fh;
}

=head2 stopmatch I<REGEX>

Returns a regular expression that matches everything up to but not
including the given I<REGEX>.
This is something similar to

	[^...]

where "not to be matched" isn't from a given set of characters, but by
the given regular expression.

=head3 Examples

Match everything up to a word in capital letters

	$re = stopmatch qr{\b[A-Z]+\b};
	$found = /($re)/ for 'Some text up to THIS word';
	# $found is 'Some text up to '

=cut

sub stopmatch {
	my $stop = shift;
	return qr{(?:(?!$stop).)*};
}

=head2 narray I<subref> I<d1> ... I<dn>

Returns a reference to a I<n>-dimensional array.

I<subref> is a reference to a sub expecing I<n> arguments
and returning the disired value for C<< $a->[x1]...[xn] >>.
and I<di> is the size in the I<i>-th dimension.

=head3 Examples

Create simple array ref of 5 elements:

	$ar = narray {$_[0]} 5;
	# $ar = [0, 1, 2, 3, 4]

Create 3x3 matrix:

	$m = narray {3 * $_[0] + $[1]} 3, 3;
	# $m = [[0, 1, 2], [3, 4, 5], [6, 7, 8]]

=cut

sub narray (&@);
sub narray (&@) {
    my $val = shift;
    my $size = shift;
	[map {my $i = $_;
		@_ ? narray {&$val($i, @_)} @_ : &$val($i)} (0 .. $size - 1)];
}

=head1 SEE ALSO

L<Exporter::Tiny::Manual::Importing>

=head1 AUTHOR

Jörg Sommrey, C<< <28217714+jo-37 at users.noreply.github.com> >>

=head1 LICENSE AND COPYRIGHT

Copyright 2020 Jörg Sommrey.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

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


=cut

1; # End of Jo::Util
