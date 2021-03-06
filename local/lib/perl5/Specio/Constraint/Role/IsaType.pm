package Specio::Constraint::Role::IsaType;

use strict;
use warnings;

our $VERSION = '0.36';

use Specio::PartialDump qw( partial_dump );
use Storable qw( dclone );

use Role::Tiny;

use Specio::Constraint::Role::Interface;
with 'Specio::Constraint::Role::Interface';

{
    ## no critic (Subroutines::ProtectPrivateSubs)
    my $attrs = dclone( Specio::Constraint::Role::Interface::_attrs() );
    ## use critic

    for my $name (qw( parent _inline_generator )) {
        $attrs->{$name}{init_arg} = undef;
        $attrs->{$name}{builder}
            = $name =~ /^_/ ? '_build' . $name : '_build_' . $name;
    }

    $attrs->{class} = {
        isa      => 'ClassName',
        required => 1,
    };

    ## no critic (Subroutines::ProhibitUnusedPrivateSubroutines)
    sub _attrs {
        return $attrs;
    }
}

## no critic (Subroutines::ProhibitUnusedPrivateSubroutines)
sub _wrap_message_generator {
    my $self      = shift;
    my $generator = shift;

    my $class = $self->class;

    unless ( defined $generator ) {
        $generator = sub {
            my $description = shift;
            my $value       = shift;

            return
                  "Validation failed for $description with value "
                . partial_dump($value)
                . '(not isa '
                . $class . ')';
        };
    }

    my $d = $self->description;

    return sub { $generator->( $d, @_ ) };
}
## use critic

1;

# ABSTRACT: Provides a common implementation for Specio::Constraint::AnyIsa and Specio::Constraint::ObjectIsa

__END__

=pod

=encoding UTF-8

=head1 NAME

Specio::Constraint::Role::IsaType - Provides a common implementation for Specio::Constraint::AnyIsa and Specio::Constraint::ObjectIsa

=head1 VERSION

version 0.36

=head1 DESCRIPTION

See L<Specio::Constraint::AnyIsa> and L<Specio::Constraint::ObjectIsa> for details.

=head1 SUPPORT

Bugs may be submitted at L<https://github.com/houseabsolute/Specio/issues>.

I am also usually active on IRC as 'autarch' on C<irc://irc.perl.org>.

=head1 SOURCE

The source code repository for Specio can be found at L<https://github.com/houseabsolute/Specio>.

=head1 AUTHOR

Dave Rolsky <autarch@urth.org>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2012 - 2017 by Dave Rolsky.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)

The full text of the license can be found in the
F<LICENSE> file included with this distribution.

=cut
