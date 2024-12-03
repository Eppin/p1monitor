from nacl.signing import VerifyKey
from nacl.encoding import Base64Encoder

MAGIC_SEED = 'ab64e67aac269d'

digital_signing_verify_keys_b64 = {
    '1' : 'fDJE5j7z+yaCsnLuNLWj0uZLt7drR00z/rl0flNLzSo=',
    '2' : 'ng9OlUvD+4bz1Moy7mr/9xXTiJOZ1jnwsQgkLf2Jy6o=',
    '3' : '24Ma5jJBxVoDDpFzq5apWFqOKzDTUz5cZCrvsjDRA4U=',
    '4' : 'qU4QgfHP7BQBpyWnxAbrhxS1PtuJjVYewpUdiwWjwAA='
}

debug=True

#######################################################
# verify the file with a verify key and write a file  #
# without the digital signature source_filepath,      #
# destination_filepath, verify_key_b64 are mandatory  #
#######################################################
def verify_write_file( source_filepath=None, destination_filepath=None, verify_key_b64=None ):
    if source_filepath == None:
        raise Exception( "source_filepath niet opgeven " )

    if destination_filepath == None:
        raise Exception( "destination_filepath niet opgeven " )

    if verify_key_b64 == None:
        raise Exception( "verify_key_b64 key niet opgeven " )

    if debug:
        print ( "DEBUG verify_write_file: filepath = " + source_filepath )
    try:
        f = open( source_filepath, 'rb')
        signed = f.read()
        f.close()
    except Exception as e:
        raise Exception( "lezen van bestand " + source_filepath  + " gefaald" )

    try:
        verify_key = VerifyKey( verify_key_b64, encoder=Base64Encoder)
        verified_data = verify_key.verify( signed )
        
        if debug:
            print ("DEBUG verify_write_file: -----------------")
            print ("DEBUG verify_write_file: [*] data signed.")
            print ( signed )
            print ("DEBUG verify_write_file:[*] data verified.")
            print ( verified_data )
            print ("DEBUG verify_write_file: -----------------")

    except Exception as e:
        raise Exception( "verifying gefaald " + str(e))

    try:
        f = open( destination_filepath, 'wb')
        f.write( verified_data )
        f.close()
    except Exception as e:
        raise Exception( "schrijven van bestand " + destination_filepath  + " gefaald." )

    if debug:
        print ("DEBUG verify_write_file: "+ destination_filepath + " succesvol weggeschreven.")

##################################################
# when verification and extraction is succesfull #
# return true                                    #
##################################################
def extract_signed_file(source_filepath=None, destination_filepath=None ):

    r=False
    for idx in range( 1, len(digital_signing_verify_keys_b64 )+1 ):
        try:
            verify_write_file( source_filepath=source_filepath, destination_filepath=destination_filepath, verify_key_b64=digital_signing_verify_keys_b64[str(idx)] )
            msg = ": verificatie van digitale handtekening met index " + str(idx) + " succesvol."
            writeLineToStatusFile( msg )
            print ( inspect.stack()[0][3] + msg )
            r=True
            break
        except Exception as e:
            print ( e )
            pass
    return r

extract_signed_file('V242P001.signed.zip', 'V242P001.zip')