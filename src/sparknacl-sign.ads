package SPARKNaCl.Sign
  with SPARK_Mode => On
is
   --  Limited, so no assignment or comparison, and always
   --  pass-by-reference.
   type Signing_PK is limited private;
   type Signing_SK is limited private;

   --------------------------------------------------------
   --  Public key signatures
   --------------------------------------------------------

   procedure Keypair (PK : out Signing_PK;
                      SK : out Signing_SK)
     with Global => Random.Entropy;

   function Serialize (K : in Signing_SK) return Bytes_64
     with Global => null;

   function Serialize (K : in Signing_PK) return Bytes_32
     with Global => null;

   procedure Sanitize (K : out Signing_PK)
     with Global => null;

   procedure Sanitize (K : out Signing_SK)
     with Global => null;


   --  MBP = "Max Byte Product"
   MBP        : constant := (255 * 255);
   Max_X_Limb : constant := (32 * MBP) + 255;

   function ModL (X : in I64_Seq_64) return Bytes_32
     with Global => null,
          Pre    => (for all K in Index_64 => X (K) in 0 .. Max_X_Limb);
   --


   procedure Sign (SM :    out Byte_Seq;
                   M  : in     Byte_Seq;
                   SK : in     Signing_SK)
     with Global => null,
          Pre => (M'First   = 0 and
                  SM'First  = 0 and
                  M'Last   <= N32'Last - 64) and then
                 (SM'Length = M'Length + 64 and
                  SM'Last   = M'Last + 64);

   procedure Open (M      :    out Byte_Seq;
                   Status :    out Boolean;
                   MLen   :    out I32;
                   SM     : in     Byte_Seq;
                   PK     : in     Signing_PK)
     with Global => null,
          Pre => M'First   = 0 and
                 SM'First  = 0 and
                 SM'Length = M'Length and
                 SM'Last   = M'Last and
                 SM'Length >= 64;

private
   --  Note - also limited types here in the full view to ensure
   --  no assignment and pass-by-reference in the body.
   type Signing_PK is limited record
      F : Bytes_32;
   end record;

   type Signing_SK is limited record
      F : Bytes_64;
   end record;

end SPARKNaCl.Sign;
