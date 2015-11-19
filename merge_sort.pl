#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';
use Data::Printer;
use Data::Dumper;
use Test::More;

# Main function
sub m_sort{
    my $list = shift;
    return [] if isEmpty($list);
    return first_half($list) if isEmpty(second_half($list));
    return merge(m_sort(first_half($list)), m_sort(second_half($list)));
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
    if ( isEmpty($l1)) { return ( @{$merged}, @{$l2})};
    if ( isEmpty($l2)) { return ( @{$merged}, @{$l1})};

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

is_deeply(m_sort([1,5,2,3]), [1,2,3,5]);
is_deeply(m_sort([]), []);
is_deeply(m_sort([1]), [1]);
is_deeply(m_sort([2,1]), [1,2]);
is_deeply(m_sort([3,1,2]), [1,2,3]);
is_deeply(m_sort([3,2,1]), [1,2,3]);
is_deeply(m_sort([1,2,3]), [1,2,3]);
is_deeply(m_sort([1,2,3,4]), [1,2,3,4]);
is_deeply(m_sort([1,4,3,2]), [1,2,3,4]);
is_deeply(m_sort([3,4,1,2]), [1,2,3,4]);
is_deeply(m_sort([5,2,4,1,3,7,6,9,2,5,1,7,9]), [1,1,2,2,3,4,5,5,6,7,7,9,9]);

done_testing();

sub first {
    my $l = shift;
    return $l->[0];
}

sub rest {
    my $l = shift;
    my $len = sizeof($l);
    my @rest = @{$l}[1..$len-1];
    return \@rest;
}

sub sizeof {
    my $l = shift;
    return scalar @{$l};
}

sub isEmpty{
    my $l = shift;
    return scalar @{$l} == 0;
}

sub first_half {
    my $l = shift;
    my $size = sizeof($l);
    return [] if isEmpty($l);
    my @fh = @{$l}[0..($size/2)-0.5];
    return \@fh;
}

sub second_half {
    my $l = shift;
    my $size = sizeof($l);
    return [] if isEmpty($l);
    my @fh = @{$l}[($size/2)+0.5..$size-1];
    return \@fh;
}