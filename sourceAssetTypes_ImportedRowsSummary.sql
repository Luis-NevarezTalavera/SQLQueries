Select s."ContentOwner_Name", s."stream", Count(s."AssetID")
From public.sourceassettypes s
--Where s."stream" = 'VIDEO'
Group by s."ContentOwner_Name", s."stream"
Order by s."ContentOwner_Name", Count(s."AssetID") desc

--ALTER TABLE public.sourceassettypes ALTER COLUMN "Version" TYPE varchar(300);
--Update public.sourceassettypes s set "filewrapper" = 'MPEG Transport Stream' where s."filename" like '%.mpg' and s."filewrapper" IsNull
--Update public.sourceassettypes s set "filewrapper" = 'MXF' where s."filename" like '%.mxf' and s."filewrapper" IsNull
--Update public.sourceassettypes s set "filewrapper" = 'QuickTime' where s."filename" like '%.mov' and s."filewrapper" IsNull
--Update public.sourceassettypes s set "filewrapper" = 'XML' where s."filename" like '%.xml' and s."filewrapper" IsNull
--Update public.sourceassettypes s set "filewrapper" = 'XML' where s."codec" = 'JPEG 2000' and s."filewrapper" IsNull