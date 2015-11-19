#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';
use Data::Printer;
use Data::Dumper;
use Test::More;

# Main function
sub merge_sort{
    my $list = shift;
    return [] if is_empty($list);
    return first_half($list) if is_empty(second_half($list));
    return merge(
        merge_sort(first_half($list)),
        merge_sort(second_half($list))
    );
}

# The merge part
sub merge {
    my ($li1, $li2) = @_;
    my @merged = _merge([], $li1, $li2);
    return \@merged;
}

# Recursive definition of merging
sub _merge {
    my ($merged, $l1, $l2) = @_;
    return (@{$merged}, @{$l2}) if is_empty($l1);
    return (@{$merged}, @{$l1}) if is_empty($l2);

    if (first($l1) < first($l2)){
        my @next_merged = (@{$merged}, first($l1));
        return _merge(\@next_merged, rest($l1), $l2);
    } else {
        my @next_merged = (@{$merged}, first($l2));
        return _merge(\@next_merged, $l1, rest($l2));
    }
}

is_deeply(merge ([1,3], [2,4]), [1,2,3,4]);
is_deeply(merge ([1,2], [3,4]), [1,2,3,4]);
is_deeply(merge ([2,3], [1,4]), [1,2,3,4]);
is_deeply(merge ([1, 2,3], [1,2, 4]), [1,1,2,2,3,4]);
is_deeply(merge ([3, 4, 7], [1,5,7]), [1,3,4,5,7,7]);
my $l = [1,2,3];
is(first($l), 1);
is_deeply(rest($l), [2,3]);
is_deeply(merge([1,3,4], [2]), [1,2,3,4]);

is_deeply(first_half([1,2,3]),[1,2]);
is_deeply(second_half([1,2,3]), [3]);
is_deeply(first_half([]), []);
is_deeply(first_half([1]), [1]);
is_deeply(first_half([1,2]), [1]);
is_deeply(first_half([1,2,3]), [1,2]);
is_deeply(first_half([1,2,3,4]), [1,2]);
is_deeply(first_half([1,2,3,4,5]), [1,2,3]);
is_deeply(second_half([]), []);
is_deeply(second_half([1]), []);
is_deeply(second_half([1,2]), [2]);
is_deeply(second_half([1,2,3]), [3]);
is_deeply(second_half([1,2,3,4]), [3,4]);
is_deeply(second_half([1,2,3,4,5]), [4,5]);

is_deeply(merge_sort([1,5,2,3]), [1,2,3,5]);
is_deeply(merge_sort([]), []);
is_deeply(merge_sort([1]), [1]);
is_deeply(merge_sort([2,1]), [1,2]);
is_deeply(merge_sort([3,1,2]), [1,2,3]);
is_deeply(merge_sort([3,2,1]), [1,2,3]);
is_deeply(merge_sort([1,2,3]), [1,2,3]);
is_deeply(merge_sort([1,2,3,4]), [1,2,3,4]);
is_deeply(merge_sort([1,4,3,2]), [1,2,3,4]);
is_deeply(merge_sort([3,4,1,2]), [1,2,3,4]);
is_deeply(merge_sort([5,2,4,1,3,7,6,9,2,5,1,7,9]), [1,1,2,2,3,4,5,5,6,7,7,9,9]);

done_testing();

sub first {
    return shift->[0];
}

sub rest {
    my $l = shift;
    my $len = size_of($l);
    my @rest = @{$l}[1..$len-1];
    return \@rest;
}

sub size_of {
    my $l = shift;
    return scalar @{$l};
}

sub is_empty{
    my $l = shift;
    return scalar @{$l} == 0;
}

sub half_from_to {
    my ($low_bown, $high_bound, $l) = @_;
    my $size = size_of($l);
    return [] if is_empty($l);
    my @fh = @{$l}[$low_bown->($size)..$high_bound->($size)];
    return \@fh;
}

sub first_half {
    return half_from_to(
        sub {0},
        sub {my ($size) = @_; ($size/2)-0.5},
        shift
    );
}

sub second_half {
    return half_from_to(
        sub{my ($size) = @_; ($size/2)+0.5},
        sub{my ($size) = @_; $size - 1},
        shift
    );
}