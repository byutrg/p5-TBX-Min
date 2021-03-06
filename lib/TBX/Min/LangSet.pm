package TBX::Min::LangSet;
use strict;
use warnings;
use Carp;
# VERSION

# ABSTRACT: Store information from one TBX-Min C<langSet> element
=head1 SYNOPSIS

    use TBX::Min::LangSet;
    use TBX::Min::TIG;
    my $lang_grp = TBX::Min::LangSet->new(
        {code => 'en'});
    print $lang_grp->lang(); # 'en'
    my $term_grp = TBX::Min::TIG->new({term => 'perl'});
    $lang_grp->add_term_group($term_grp);
    my $term_grps = $lang_grp->term_groups;
    print $#$term_grps; # '1'

=head1 DESCRIPTION

This class represents a single language group contained in a TBX-Min file.
A language group is contained by a concept termEntry, and contains several term
groups each representing a given concept for the same language.

=cut

=head1 METHODS

=head2 C<new>

Creates a new C<TBX::Min::LangSet> instance. Optionally you may pass in
a hash reference which is used to initialize the object. The allowed hash
fields are C<code> and C<term_groups>, where C<code> corresponds to the
method of the same name, and C<term_groups> is an array reference containing
C<TBX::Min::LangSet> objects.

=cut
my %valid = map {$_ => 1} qw(code term_groups);
sub new {
    my ($class, $args) = @_;
    my $self;
    if((ref $args) eq 'HASH'){
        # validate arguments
        if(my @invalids = grep {!$valid{$_}} sort keys %$args){
            croak 'Invalid attributes for class: ' .
                join ' ', @invalids
        }
        if($args->{term_groups} && ref $args->{term_groups} ne 'ARRAY'){
            croak q{Attribute 'term_groups' should be an array reference};
        }
        $self = $args;
    }else{
        $self = {};
    }
    $self->{term_groups} ||= [];
    return bless $self, $class;
}

=head2 C<code>

Get or set the language group language code (should be ISO 639 and 3166,
e.g. C<en-US>, C<de>, etc.).

=cut
sub code {
    my ($self, $code) = @_;
    if($code) {
        return $self->{code} = $code;
    }
    return $self->{code};
}

=head2 C<term_groups>

Returns an array ref containing all of the C<TBX::Min::TIG> objects
in this concept termEntry. The array ref is the same one used to store the objects
internally, so additions or removals from the array will be reflected in future
calls to this method.

=cut
sub term_groups { ## no critic(RequireArgUnpacking)
    my ($self) = @_;
    if (@_ > 1){
        croak 'extra argument found (term_groups is a getter only)';
    }
    return $self->{term_groups};
}

=head2 C<add_term_group>

Adds the input C<TBX::Min::TIG> object to the list of language groups
contained by this object.

=cut
sub add_term_group {
    my ($self, $term_grp) = @_;
    if( !$term_grp || !$term_grp->isa('TBX::Min::TIG') ){
        croak 'argument to add_term_group should be a TBX::Min::TIG';
    }
    push @{$self->{term_groups}}, $term_grp;
    return;
}

=head1 SEE ALSO

L<TBX::Min>

=cut

1;
