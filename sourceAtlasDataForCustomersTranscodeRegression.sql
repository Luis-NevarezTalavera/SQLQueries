--parse data to come up with asset attribute groups and their versions, providing Neel/qa w versions to test
--Count AssetId Container   VideoCodec  AudioCodec  FPS ScanType    ScanOrder   Width   Height  DAR FirstAudio  LastAudio   Tracks  AudioSampleRate AudioBitDepth   CC_EMBEDDED
-- Tracks:  track count
-- first Audio:  of the tracks, list the 1st channel
--complex stream asset export
select
        a.hrid                                          "ONE_AssetID"
    ,   a.assetid                                       "ONE_AssetUUID"
    ,   a.filename
    ,   a.filesize
    ,   a.filewrapper
    ,   a.status                                        "Asset_Status"
    ,   a.createddate at time zone 'UTC'                "Asset createddatetime UTC"
    ,   str.stream
    ,   t.hrid                                          "TitleHRID"
    ,   coalesce(c.hrid, '')                            "CGID"
    ,   v.hrid                                          "VersionID"
    ,   v.name                                          "Version"
    ,   t.titletype
    ,   str.pic_ar                                      "Picture_A/R"
    ,   str.dis_ar                                      "Display_A/R"
    ,   str.pic_format                                  "Picture_Format"
    ,   a.framerate                                     "Frame_Rate"
    ,   str.scantype
    ,   str.codec
    ,   str.bitdepth
    ,   str.samplerate
    ,   str.channelconfig                               "Channel_Config"
    ,   str.sub_type                                    "Audio_Subtype"
    ,   str.language
    ,   str.subtitlelang
    ,   str.subtitletype
    ,   str.width
    ,   str.height
from    (   select  assetid, stream, stream_type, sub_type, channelconfig, "language", width, height, pic_ar, dis_ar, pic_format, colorspace, codec, duration, bitdepth, samplerate, subtitlelang, subtitleclsd, subtitletype, coding, scantype, embedtype
            from
                            (   select  aa.assetid, aa.assetaudioid,    'AUDIO'     stream, aa.type         stream_type, aad.subtype    sub_type,           aa.channelconfig,   "language", ''                          width, ''                       height, ''                  pic_ar, ''                  dis_ar, ''              pic_format, ''          colorspace, aad.audiocodec  codec,  aad.actuallength    duration, aad.bitdepth,     aad.samplerate, ''              subtitlelang, ''                    subtitleclsd, ''            subtitletype, ''        coding, ''              scantype, ''    embedtype   from assetaudio aa join (select distinct audiocodec, bitdepth, samplerate, assetaudioid, subtype, actuallength from assetaudiodetail) aad on aad.assetaudioid = aa.assetaudioid) a
                    union   (   select  assetid,                        'IMAGE'     stream, graphicstype    stream_type, ''             sub_type, ''        channelconfig,      "language", framesizewidth::citext      width, framesizeheight::citext  height, ''                  pic_ar, ''                  dis_ar, ''              pic_format, ''          colorspace, ''              codec,  ''                  duration, ''    bitdepth,   ''  samplerate, ''              subtitlelang, ''                    subtitleclsd, ''            subtitletype, ''        coding, ''              scantype, ''    embedtype   from assetimage)
                    union   (   select  assetid,                        'VIDEO'     stream, subtype         stream_type, ''             sub_type, ''        channelconfig,      av."language", framesizewidth::citext   width, framesizeheight::citext  height, pictureaspectratio  pic_ar, displayaspectratio  dis_ar, pictureformat   pic_format, primaries   colorspace, videocodec      codec,  ''                  duration, ''    bitdepth,   ''  samplerate, avs."language"  subtitlelang, avs.closed::citext    subtitleclsd, avs."type"    subtitletype, ''        coding, av.scantype     scantype, ''    embedtype   from assetvideo av left join assetvideosubtitlelanguage avs on av.assetvideoid = avs.assetvideoid)
                    union   (   select  assetid,                        'SUBTITLE'  stream, format          stream_type, ''             sub_type, ''        channelconfig,      "language", ''                          width, ''                       height, ''                  pic_ar, ''                  dis_ar, ''              pic_format, ''          colorspace, ''              codec,  ''                  duration, ''    bitdepth,   ''  samplerate, "language"      subtitlelang, ''                    subtitleclsd, format        subtitletype, coding    coding, ''              scantype, ''    embedtype   from assetsubtitle)
                    union   (   select  assetid,                        'NON-MEDIA' stream, ''              stream_type, ''             sub_type, ''        channelconfig,      "language", ''                          width, ''                       height, ''                  pic_ar, ''                  dis_ar, ''              pic_format, ''          colorspace, ''              codec,  ''                  duration, ''    bitdepth,   ''  samplerate,     ''          subtitlelang, ''                    subtitleclsd, ''            subtitletype, ''        coding, ''              scantype, ''    embedtype   from assetnonmedia)
        )               str
join    asset           a               on str.assetid  = a.assetid
                                        and a.isactive  = '1'
                                        and a.status    != 'Deleted'
join        titleversion                v       on a.titleversionid             = v.titleversionid
                                                and v.isactive                  = '1'
left join   titleversionconformance     c       on a.titleversionconformanceid  = c.titleversionconformanceid
                                                and c.isactive                  = '1'
left join   title                       t       on v.titleid                    = t.titleid
                                                and t.isactive                  = '1'
where
        a.isactive          = '1'
    and a.status            != 'Deleted'
    and a.function          = 'Source'
    and t.contentownerid    = 'xxxxxx'

    -- Charter:  6f6b9fae
    -- Disney:  36ddc6f5
    -- Shaw:  057a75b7
    -- Funi:  767f0752
    -- Rogers:  ff963afd
    -- MGM:  5c7a7727
    -- Amazon:  24618bdb
    -- Warner Bros.:  dd3c61f4
    -- c4bec174:  Banijay Rights
    -- e3b59a42:  Sony
    -- b714390b:  AT&T
    -- 8d1c6890:  Lionsgate
    -- 7121f949:  Netflix
    -- 99df663a:  VMI Virgin Media Ireland
-- limit 25