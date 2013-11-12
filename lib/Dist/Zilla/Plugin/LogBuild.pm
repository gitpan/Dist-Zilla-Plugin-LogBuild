package Dist::Zilla::Plugin::LogBuild;

use 5.010;
use Moose;
with 'Dist::Zilla::Role::FileGatherer';

our $VERSION = '0.01'; # VERSION

use namespace::autoclean;

has filename => (
    is  => 'ro',
    isa => 'Str',
    default => 'build.log',
);

sub gather_files {
    require Dist::Zilla::File::FromCode;

    my ($self, $arg) = @_;

    my $zilla = $self->zilla;
    my $file  = Dist::Zilla::File::FromCode->new({
        name => $self->filename,
        code_return_type => 'text',
        code => sub {
            my @ct;

            push @ct, "* This distribution is built with Dist::Zilla ".
                "$Dist::Zilla::VERSION on ${\(scalar localtime)}\n\n";

            push @ct, "* Loaded Dist::Zilla plugins\n";
            for (sort keys %INC) {
                next unless m!^\ADist/Zilla/Plugin!;
                no strict 'refs';
                my $pkg = $_; $pkg =~ s!/!::!g; $pkg =~ s/\.pm\z//;
                push @ct, "  - $pkg ".(${"$pkg\::VERSION"} // 0)."\n";
            }
            push @ct, "\n";

            push @ct, "* Loaded Pod::Weaver plugins\n";
            for (sort keys %INC) {
                next unless m!^\APod/Weaver(?:/Plugin|\.)!;
                no strict 'refs';
                my $pkg = $_; $pkg =~ s!/!::!g; $pkg =~ s/\.pm\z//;
                push @ct, "  - $pkg ".(${"$pkg\::VERSION"} // 0)."\n";
            }
            push @ct, "\n";

            return join "", @ct;
        },
    });
    $self->add_file($file);
    return;
}

__PACKAGE__->meta->make_immutable;
1;
# ABSTRACT: Add build information file (build.log)

__END__

=pod

=encoding UTF-8

=head1 NAME

Dist::Zilla::Plugin::LogBuild - Add build information file (build.log)

=head1 VERSION

version 0.01

=head1 SYNOPSIS

In your F<dist.ini>:

  [LogBuild]

=head1 DESCRIPTION

This plugin generates a C<build.log> file containing build information (like the
list of loaded plugins and their versions) to aid in debugging.

=head1 FUNCTIONS


None are exported by default, but they are exportable.

=head1 SEE ALSO

L<Dist::Zilla>

=head1 HOMEPAGE

Please visit the project's homepage at L<https://metacpan.org/release/Dist-Zilla-Plugin-LogBuild>.

=head1 SOURCE

Source repository is at L<https://github.com/sharyanto/perl-Dist-Zilla-Plugin-LogBuild>.

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website
L<https://rt.cpan.org/Public/Dist/Display.html?Name=Dist-Zilla-Plugin-LogBu
ild>

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

=head1 AUTHOR

Steven Haryanto <stevenharyanto@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Steven Haryanto.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
