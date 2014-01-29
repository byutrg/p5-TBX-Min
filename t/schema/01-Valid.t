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
        <entry id="C002">
            <langGroup xml:lang="en">
                <termGroup>
                    <term>dog</term>
                </termGroup>
            </langGroup>
        </entry>
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
        <entry id="C002">
            <langGroup xml:lang="en">
                <termGroup>
                    <term>dog</term>
                </termGroup>
            </langGroup>
        </entry>
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
        <entry id="C002">
            <langGroup xml:lang="en">
                <termGroup>
                    <term>dog</term>
                </termGroup>
            </langGroup>
        </entry>
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
        <entry id="C002">
            <langGroup xml:lang="en">
                <termGroup>
                    <term>dog</term>
                </termGroup>
            </langGroup>
        </entry>
    </body>
</TBX>

=== multiple entries
--- input
<?xml version='1.0' encoding="UTF-8"?>
<TBX dialect="TBX-Min">
    <header>
        <id>TBX sample</id>
        <languages source="de" target="en"/>
    </header>
    <body>
        <entry id="C002">
            <langGroup xml:lang="en">
                <termGroup>
                    <term>dog</term>
                </termGroup>
            </langGroup>
        </entry>
        <entry id="C003">
            <langGroup xml:lang="en">
                <termGroup>
                    <term>dog</term>
                </termGroup>
            </langGroup>
        </entry>
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
        <entry id="C002">
            <subjectField>whatever</subjectField>
            <langGroup xml:lang="en">
                <termGroup>
                    <term>dog</term>
                </termGroup>
            </langGroup>
        </entry>
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
        <entry id="C002">
            <langGroup xml:lang="en">
                <termGroup>
                    <term>dog</term>
                </termGroup>
            </langGroup>
            <subjectField>whatever</subjectField>
        </entry>
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
        <entry id="C002">
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
        </entry>
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
        <entry id="C002">
            <langGroup xml:lang="en">
                <termGroup>
                    <term>dog</term>
                    <note>cute!</note>
                    <termStatus>preferred</termStatus>
                    <customer>SAP</customer>
                    <partOfSpeech>noun</partOfSpeech>
                </termGroup>
            </langGroup>
        </entry>
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
        <entry id="C002">
            <langGroup xml:lang="en">
                <termGroup>
                    <partOfSpeech>noun</partOfSpeech>
                    <customer>SAP</customer>
                    <note>cute!</note>
                    <termStatus>preferred</termStatus>
                    <term>dog</term>
                </termGroup>
            </langGroup>
        </entry>
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
        <entry id="C002">
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
                    <partOfSpeech>other</partOfSpeech>
                </termGroup>
            </langGroup>
        </entry>
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
        <entry id="C002">
            <langGroup xml:lang="en">
                <termGroup>
                    <term>dog</term>
                    <termStatus>preferred</termStatus>
                </termGroup>
                <termGroup>
                    <term>dog</term>
                    <termStatus>admitted</termStatus>
                </termGroup>
                <termGroup>
                    <term>dog</term>
                    <termStatus>notRecommended</termStatus>
                </termGroup>
                <termGroup>
                    <term>dog</term>
                    <termStatus>obsolete</termStatus>
                </termGroup>
            </langGroup>
        </entry>
    </body>
</TBX>