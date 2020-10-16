defmodule SupercolliderCubes.AudioPipeline.Pipeline do
  use Membrane.Pipeline
  use Membrane.Log

  @impl true
  def handle_init(%{output_path: output_path}) do
    children = %{
      stream: %Membrane.Element.PortAudio.Source{
        endpoint_id: 3
      },
      encoder: %Membrane.Element.FDK.AAC.Encoder{
        input_caps: %Membrane.Caps.Audio.Raw{
          channels: 2,
          format: :s16le,
          sample_rate: 48_000
        }
      },
      parser: %Membrane.AAC.Parser{
        out_encapsulation: :none
      },
      payloader: Membrane.MP4.Payloader.AAC,
      muxer: Membrane.MP4.CMAF.Muxer,
      hls: %Membrane.HTTPAdaptiveStream.Sink{
        manifest_name: Path.basename(output_path),
        manifest_module: Membrane.HTTPAdaptiveStream.HLS,
        storage: %Membrane.HTTPAdaptiveStream.Storages.FileStorage{
          directory: Path.dirname(output_path)
        }
      }
    }

    links = [
      link(:stream)
      |> to(:encoder)
      |> to(:parser)
      |> to(:payloader)
      |> to(:muxer)
      |> to(:hls)
    ]

    spec = %ParentSpec{
      children: children,
      links: links
    }

    {{:ok, spec: spec}, %{}}
  end
end
