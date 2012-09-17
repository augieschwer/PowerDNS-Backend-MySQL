package PowerDNS::Backend::Base;

# ABSTRACT: Base class for PowerDNS backends

use Carp;
use strict;
use warnings;

=head1 NAME

PowerDNS::Backend::Base - Base class for PowerDNS backends

=head1 VERSION

Version 0.11

=cut

our $VERSION = '0.11';

=head1 SYNOPSIS

    use base 'PowerDNS::Backend::Base';

    sub foo {
    }

=head1 DESCRIPTION

PowerDNS::Backend::Base provides the base class for PowerDNS
backend classes. Its not useful on its own.

=head1 METHODS

=head2 new(\%params)

    my %params = ();

    my $pdns = PowerDNS::Backend::Foo->new(\%params);

    Creates a PowerDNS::Backend::Foo object.

=back

=cut

sub _connect; # STUB!

sub new {
    my $class  = shift;
    my $params;

    if (ref $_[0]) {
        $params = shift;
    }
    else {
        die 'Bad arguments' if scalar @_ % 2;
        %$params = @_
    }

    my $self   = {};

    bless $self, ref $class || $class;

    $self->{'lock_timeout'} =
      defined $params->{lock_timeout} ? $params->{lock_timeout} : 3;
    $self->{'lock_name'} =
      defined $params->{lock_name}
      ? $params->{lock_name}
      : lc(join('_', split('::', __PACKAGE__)));

    $self->{'dbh'} = _connect($params);

    $self->{'error_msg'} = undef;

    return $self;
}

sub _convertscalarrefs {
    return map {ref $_ eq 'SCALAR' ? ${$_} : $_ } @_;
}

sub DESTROY {
    my $self = shift;
    if ( defined $self->{'dbh'} ) {
        delete $self->{'dbh'} or warn "$!\n";
    }
}
=head1 AUTHOR

Dean Hamstead, C<< <dean at fragfest.com.au> >>

http://www.schwer.us

=head1 BUGS

Please report any bugs or feature requests to
C<bug-net-powerdns-backend-MySQL at rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=PowerDNS-Backend-MySQL>.
I will be notified, and then you'll automatically be notified of progress on
your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc PowerDNS::Backend

    You can also look for information at:

=over 4

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/PowerDNS-Backend>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/PowerDNS-Backend>

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=PowerDNS>

=item * Search CPAN

L<http://search.cpan.org/dist/PowerDNS-Backend>

=item * Github

L<https://github.com/augieschwer/PowerDNS-Backend-MySQL>

=back

=head1 ACKNOWLEDGEMENTS

I would like to thank Sonic.net for allowing me to release this to the public.

=head1 COPYRIGHT & LICENSE

Copyright 2012 Dean Hamstead, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=head1 VERSION

    0.11

=cut

