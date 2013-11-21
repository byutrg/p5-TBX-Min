# Test correct TBX-Min examples against the RNG and XSD schemas
use strict;
use warnings;
use t::Schema::TestSchema;
plan tests => 2*blocks();

for my $block(blocks()){
    my $errors = rng_validate($block->input);
    is($errors, undef, 'RNG: ' . $block->name);

    $errors = xsd_validate($block->input);
    is($errors, undef, 'XSD: ' . $block->name);
}

__DATA__
=== bare bones file
--- input
<?xml version='1.0' encoding="UTF-8"?>
<TBX dialect="TBX-Min">
    <header>
        <id>TBX sample</id>
        <languages source="de" target="en"/>
    </header>
    <body>
        <conceptEntry id="C002">
            <langGroup xml:lang="en">
                <termGroup>
                    <term>dog</term>
                </termGroup>
            </langGroup>
        </conceptEntry>
    </body>
</TBX>

=== full header
--- input
<?xml version='1.0' encoding="UTF-8"?>
<TBX dialect="TBX-Min">
    <header>
        <id>TBX sample</id>
        <languages source="de" target="en"/>
        <description>A short sample file demonstrating TBX-Min</description>
        <dateCreated>2013-11-12T00:00:00</dateCreated>
        <creator>Klaus-Dirk Schmidt</creator>
        <directionality>bidirectional</directionality>
        <license>CC BY license can be freely copied and modified</license>
    </header>
    <body>
        <conceptEntry id="C002">
            <langGroup xml:lang="en">
                <termGroup>
                    <term>dog</term>
                </termGroup>
            </langGroup>
        </conceptEntry>
    </body>
</TBX>

=== different order in header
--- input
<?xml version='1.0' encoding="UTF-8"?>
<TBX dialect="TBX-Min">
    <header>
        <license>CC BY license can be freely copied and modified</license>
        <directionality>bidirectional</directionality>
        <creator>Klaus-Dirk Schmidt</creator>
        <description>A short sample file demonstrating TBX-Min</description>
        <dateCreated>2013-11-12T00:00:00</dateCreated>
        <languages source="de" target="en"/>
        <id>TBX sample</id>
    </header>
    <body>
        <conceptEntry id="C002">
            <langGroup xml:lang="en">
                <termGroup>
                    <term>dog</term>
                </termGroup>
            </langGroup>
        </conceptEntry>
    </body>
</TBX>

=== monodirectional
--- input
<?xml version='1.0' encoding="UTF-8"?>
<TBX dialect="TBX-Min">
    <header>
        <id>TBX sample</id>
        <languages source="de" target="en"/>
        <directionality>monodirectional</directionality>
    </header>
    <body>
        <conceptEntry id="C002">
            <langGroup xml:lang="en">
                <termGroup>
                    <term>dog</term>
                </termGroup>
            </langGroup>
        </conceptEntry>
    </body>
</TBX>

=== multiple conceptEntries
--- input
<?xml version='1.0' encoding="UTF-8"?>
<TBX dialect="TBX-Min">
    <header>
        <id>TBX sample</id>
        <languages source="de" target="en"/>
    </header>
    <body>
        <conceptEntry id="C002">
            <langGroup xml:lang="en">
                <termGroup>
                    <term>dog</term>
                </termGroup>
            </langGroup>
        </conceptEntry>
        <conceptEntry id="C003">
            <langGroup xml:lang="en">
                <termGroup>
                    <term>dog</term>
                </termGroup>
            </langGroup>
        </conceptEntry>
    </body>
</TBX>

=== subjectField before langGroup
--- input
<?xml version='1.0' encoding="UTF-8"?>
<TBX dialect="TBX-Min">
    <header>
        <id>TBX sample</id>
        <languages source="de" target="en"/>
    </header>
    <body>
        <conceptEntry id="C002">
            <subjectField>whatever</subjectField>
            <langGroup xml:lang="en">
                <termGroup>
                    <term>dog</term>
                </termGroup>
            </langGroup>
        </conceptEntry>
    </body>
</TBX>

=== subjectField after langGroup
--- input
<?xml version='1.0' encoding="UTF-8"?>
<TBX dialect="TBX-Min">
    <header>
        <id>TBX sample</id>
        <languages source="de" target="en"/>
    </header>
    <body>
        <conceptEntry id="C002">
            <langGroup xml:lang="en">
                <termGroup>
                    <term>dog</term>
                </termGroup>
            </langGroup>
            <subjectField>whatever</subjectField>
        </conceptEntry>
    </body>
</TBX>

=== multiple langGroups
--- input
<?xml version='1.0' encoding="UTF-8"?>
<TBX dialect="TBX-Min">
    <header>
        <id>TBX sample</id>
        <languages source="de" target="en"/>
    </header>
    <body>
        <conceptEntry id="C002">
            <langGroup xml:lang="en">
                <termGroup>
                    <term>dog</term>
                </termGroup>
            </langGroup>
            <langGroup xml:lang="de">
                <termGroup>
                    <term>hund</term>
                </termGroup>
            </langGroup>
        </conceptEntry>
    </body>
</TBX>

=== full termGroup
--- input
<?xml version='1.0' encoding="UTF-8"?>
<TBX dialect="TBX-Min">
    <header>
        <id>TBX sample</id>
        <languages source="de" target="en"/>
    </header>
    <body>
        <conceptEntry id="C002">
            <langGroup xml:lang="en">
                <termGroup>
                    <term>dog</term>
                    <note>cute!</note>
                    <termStatus>approved</termStatus>
                    <customer>SAP</customer>
                    <partOfSpeech>noun</partOfSpeech>
                </termGroup>
            </langGroup>
        </conceptEntry>
    </body>
</TBX>

=== different order in termGroup
--- input
<?xml version='1.0' encoding="UTF-8"?>
<TBX dialect="TBX-Min">
    <header>
        <id>TBX sample</id>
        <languages source="de" target="en"/>
    </header>
    <body>
        <conceptEntry id="C002">
            <langGroup xml:lang="en">
                <termGroup>
                    <partOfSpeech>noun</partOfSpeech>
                    <customer>SAP</customer>
                    <note>cute!</note>
                    <termStatus>approved</termStatus>
                    <term>dog</term>
                </termGroup>
            </langGroup>
        </conceptEntry>
    </body>
</TBX>

=== partOfSpeech other values
--- input
<?xml version='1.0' encoding="UTF-8"?>
<TBX dialect="TBX-Min">
    <header>
        <id>TBX sample</id>
        <languages source="de" target="en"/>
    </header>
    <body>
        <conceptEntry id="C002">
            <langGroup xml:lang="en">
                <termGroup>
                    <term>dog</term>
                    <partOfSpeech>noun</partOfSpeech>
                </termGroup>
                <termGroup>
                    <term>dog</term>
                    <partOfSpeech>verb</partOfSpeech>
                </termGroup>
                <termGroup>
                    <term>dog</term>
                    <partOfSpeech>adjective</partOfSpeech>
                </termGroup>
                <termGroup>
                    <term>dog</term>
                    <partOfSpeech>adverb</partOfSpeech>
                </termGroup>
                <termGroup>
                    <term>dog</term>
                    <partOfSpeech>properNoun</partOfSpeech>
                </termGroup>
                <termGroup>
                    <term>dog</term>
                    <partOfSpeech>sentence</partOfSpeech>
                </termGroup>
                <termGroup>
                    <term>dog</term>
                    <partOfSpeech>other</partOfSpeech>
                </termGroup>
            </langGroup>
        </conceptEntry>
    </body>
</TBX>

=== termStatus other values
--- input
<?xml version='1.0' encoding="UTF-8"?>
<TBX dialect="TBX-Min">
    <header>
        <id>TBX sample</id>
        <languages source="de" target="en"/>
    </header>
    <body>
        <conceptEntry id="C002">
            <langGroup xml:lang="en">
                <termGroup>
                    <term>dog</term>
                    <termStatus>approved</termStatus>
                </termGroup>
                <termGroup>
                    <term>dog</term>
                    <termStatus>provisional</termStatus>
                </termGroup>
                <termGroup>
                    <term>dog</term>
                    <termStatus>non-standard</termStatus>
                </termGroup>
                <termGroup>
                    <term>dog</term>
                    <termStatus>forbidden</termStatus>
                </termGroup>
            </langGroup>
        </conceptEntry>
    </body>
</TBX>