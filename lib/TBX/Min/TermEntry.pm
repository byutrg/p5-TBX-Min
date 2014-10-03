package TBX::Min::TermEntry;
use strict;
use warnings;
use Carp;
# VERSION

# ABSTRACT: Store information from one TBX-Min C<termEntry> element
=head1 SYNOPSIS

    use TBX::Min::TermEntry;
    use TBX::Min::LangSet;
    my $concept = TBX::Min::TermEntry->new(
        {id => 'B001'});
    print $concept->id(); # 'B001'
    my $lang_grp = TBX::Min::LangSet->new({code => 'en'});
    $concept->add_lang_group($lang_grp);
    my $lang_grps = $concept->lang_groups;
    print $#$lang_grps; # '1'

=head1 DESCRIPTION

This class represents a single concept termEntry contained in a TBX-Min file. A
concept termEntry contains several language groups, each containing terms that
represent this concept in a given languages.

=cut

=head1 METHODS

=head2 C<new>

Creates a new C<TBX::Min::TermEntry> instance. Optionally you may pass in
a hash reference which is used to initialize the object. The allowed hash
fields are C<id>, C<subject_field> and C<lang_groups>, where C<id> and
C<subject_field> correspond to methods of the same name, and C<langSets> is
an array reference containing C<TBX::Min::LangSet> objects.

=cut
my %valid = map +($_=>1), qw(id subject_field lang_groups);
sub new {
    my ($class, $args) = @_;
    my $self;
    if((ref $args) eq 'HASH'){
        # validate arguments
        if(my @invalids = grep !$valid{$_}, sort keys %$args){
            croak 'Invalid attributes for class: ' .
                join ' ', @invalids
        }
        if($args->{lang_groups} && ref $args->{lang_groups} ne 'ARRAY'){
            croak q{Attribute 'lang_groups' should be an array reference};
        }
        $self = $args;
    }else{
        $self = {};
    }
    $self->{lang_groups} ||= [];
    return bless $self, $class;
}

=head2 C<id>

Get or set the concept termEntry id value.

=cut
sub id {
    my ($self, $id) = @_;
    if($id) {
        return $self->{id} = $id;
    }
    return $self->{id};
}

=head2 C<subject_field>

Get or set the concept subject field string.

=cut
sub subject_field {
    my ($self, $subject_field) = @_;
    if($subject_field) {
        return $self->{subject_field} = $subject_field;
    }
    return $self->{subject_field};
}

=head2 C<lang_groups>

Returns an array ref containing all of the C<TBX::Min::LangSet> objects
in this concept termEntry. The array ref is the same one used to store the objects
internally, so additions or removals from the array will be reflected in future
calls to this method.

=cut
sub lang_groups { ## no critic(RequireArgUnpacking)
    my ($self) = @_;
    if (@_ > 1){
        croak 'extra argument found (lang_groups is a getter only)';
    }
    return $self->{lang_groups};
}

=head2 C<add_lang_group>

Adds the input C<TBX::Min::LangSet> object to the list of language groups
contained by this object.

=cut
sub add_lang_group {
    my ($self, $lang_grp) = @_;
    if( !$lang_grp || !$lang_grp->isa('TBX::Min::LangSet') ){
        croak 'argument to add_lang_group should be a TBx::Min::LangSet';
    }
    push @{$self->{lang_groups}}, $lang_grp;
    return;
}

=head1 SEE ALSO

L<TBX::Min>

=cut

1;
